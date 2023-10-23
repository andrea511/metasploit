require 'state_machines'

module SocialEngineering
  class Campaign < ApplicationRecord
    # Server config interfaces provide getters and setters for
    # virtual (serialized) attrs like host, port, SSL, etc.
    include SocialEngineering::SmtpServerConfigInterface
    include SocialEngineering::WebServerConfigInterface

    class NotExecutable < RuntimeError; end

    self.table_name = :se_campaigns

    #
    # CONSTANTS
    #
    
    CAMPAIGN_CONFIG_TYPES = ['wizard', 'custom']
    CAMPAIGN_CONFIG_TYPES_FORMATTED = [['Phishing Campaign', 'wizard'], ['Custom Campaign', 'custom']]
    # Default port to server web pages for the {SocialEngineering::Campaign}
    DEFAULT_WEB_PORT = 8080
    # Default port used by Browser Auto-Pwn (BAP)
    DEFAULT_WEB_BAP_PORT = 8081
    VALID_STATES = %w(unconfigured launchable preparing running cancelled finished interrupted)

    #
    # Associations - sorted by name
    #

    has_many :emails, :class_name => 'SocialEngineering::Email', :dependent => :destroy
    has_many :email_openings, :class_name => 'SocialEngineering::EmailOpening', :through => :emails

    has_many :portable_files, :class_name => 'SocialEngineering::PortableFile', :dependent => :destroy
    belongs_to :started_by_user, :class_name => 'Mdm::User', optional: true
    belongs_to :user, :class_name => 'Mdm::User'
    has_many :phishing_results, :class_name => 'SocialEngineering::PhishingResult', :through => :web_pages
    has_many :visits, :class_name => 'SocialEngineering::Visit', :through => :emails
    has_many :web_pages, :class_name => 'SocialEngineering::WebPage', :dependent => :destroy

    belongs_to :workspace, :class_name => 'Mdm::Workspace', :touch => true
    belongs_to :ssl_cert, :class_name => 'SSLCert', optional: true

    #
    # Callbacks - in call order
    #

    before_validation :ports_to_i
    
    #
    # Scopes
    #

    scope :running, lambda { where(:state => 'running') }
    scope :finished, lambda { where(:state => 'finished') }
    scope :with_phishing_results, lambda { includes(:emails => [:visits],
                                           :web_pages => [:phishing_results, :visits]) }
    scope :workspace_id, lambda {|workspace_id| where(:workspace_id => workspace_id)}
   
    #
    # Serializations
    #

    serialize :prefs # TODO: JSON backend

    #
    # State Machines
    #

    state_machine :state, :initial => :unconfigured do
      #
      # Ordered by event name
      # States in transitions ordered by name
      #

      event :cancel do
        transition :preparing => :cancelled
      end

      event :finish do
        transition [:running, :preparing] => :finished
      end

      event :interrupt do
        transition [:running, :preparing] => :interrupted
      end

      event :launch do
        transition [:finished, :interrupted, :launchable] => :preparing
      end

      event :reset_campaign do
        transition [:cancelled, :interrupted, :finished] => :launchable
      end

      event :run do
        transition :preparing => :running
      end

      event :set_launchable do
        transition :unconfigured => :launchable
      end

      event :unconfigure do
        transition [:cancelled, :finished, :interrupted, :launchable] => :unconfigured
      end
    end

    #
    # Validations - sorted by attribute name
    #

    validates :config_type,
              :inclusion => {
                  :in => CAMPAIGN_CONFIG_TYPES
              }
    validates :name,
              :presence => true,
              :uniqueness => {
                  :scope => :workspace_id
              },
              :length => {
                  :maximum => 100
              }
    validates :state,
              :presence => true,
              :inclusion => {
                  :in => VALID_STATES
              }
    validates :user, :presence => true
    validates :workspace, :presence => true
    validate  :validate_notification_email

    #
    # Methods - ordered by name
    #

    # Returns an array of all components, sorted by creation_date
    #
    # @return [Array<ApplicationRecord>]
    def all_components
      # refactor this into sql!!
      (self.emails + self.web_pages + self.portable_files).sort_by(&:created_at)
    end

    def bap_campaign?
      self.web_pages.each do |page|
        return true if page.attack_type == 'bap'
      end
      return false
    end

    def configure!
      if configured?
        set_launchable unless launchable?
      else
        unconfigure unless unconfigured?
      end
    end

    def email_campaign?
      emails.present?
    end

    def executable?
      !unconfigured?
    end

    def execute!(current_user)
      if executable?
        if is_running?
          CampaignRunner.stop(self)
        else
          CampaignRunner.start(self, current_user)
        end
      else
        raise NotExecutable
      end
    end

    def reset
      reset_campaign if configured?
    end

    def send_notification_email
      return unless self.notification_enabled
      message = MailMessage.new
      notification_email_recipients.each { |addr| message.add_recipient addr }
      message.subject = self.notification_email_subject
      message.from_address = 'notifications@pro.metasploit.com'
      message.body = self.notification_email_message
      ActionMailerSender.new.send(message)
    end

    def startable?
      executable? and (!is_running?)
    end

    def usb_campaign?
      portable_files.present?
    end

    def exclude_tracking?
      return self.emails[0].exclude_tracking
    end

    def uses_wizard?
      config_type == 'wizard'
    end

    # @return[Array] SocialEngineering::Visit objects for the Campaign's component Email objects
    def visits_with_targets
      emails.collect{|e| e.visits.includes(:human_target)}.flatten
    end

    # @return[Array] SocialEngineering::PhishingResult objects for the Campaign's component WebPage objects
    def phishing_results_with_targets
      web_pages.collect{|w| w.phishing_results.includes(:human_target)}.flatten
    end

    def web_campaign?
      web_pages.present?
    end

    def web_page_for_path(path)
      potential_pages = web_pages.where(:path => path)
      potential_pages.present? ? potential_pages.first : nil
    end

    # @return [":8080"] by default
    # @return [""] if web_port is 80
    def web_port_with_colon
      if self.web_port == 80
        ''
      else
        ":#{self.web_port}"
      end
    end

    def is_running?
      preparing? || running?
    end

    private

    def configured?
      ConfigurableCampaignChecker.configured?(self)
    end

    def notification_email_recipients
      if self.notification_enabled and self.notification_email_address.present?
        self.notification_email_address.split(',').map(&:strip)
      else
        []
      end
    end

    def ports_to_i
      # If these ports are about to be saved, AND they are numeric,
      # coerce them to integers.
      # Rails's numericality will not attempt to cast them to their
      # db type (which should be 'integer') since they are serialized attrs,
      # so we check that they are integers and cast them here
      integer_regex = /^\d+$/

      if self.web_bap_port.present? && self.web_bap_port.kind_of?(String) && self.web_bap_port =~ integer_regex
        self.web_bap_port = self.web_bap_port.to_i
      end

      if self.web_port.present? && self.web_port.kind_of?(String) && self.web_port =~ integer_regex
        self.web_port = self.web_port.to_i
      end

      if self.smtp_port.present? && self.smtp_port.kind_of?(String) && self.smtp_port =~ integer_regex
        self.smtp_port = self.smtp_port.to_i
      end
    end

    def validate_notification_email
      return unless self.notification_enabled
      # validate message is present
      if notification_email_message.blank?
        errors.add("Notification message", 'cannot be blank')
      end
      # validate recipients present and correctly formatted
      recipients = notification_email_recipients
      if recipients.empty?
        errors.add("Notification ", 'must contain at least one email address')
      else
        # validate all email addresses
        email_pat = /^[\S]+@[\S]+\.[\S]+$/
        failed = recipients.select { |r| r.strip.match(email_pat).nil? }
        unless failed.empty?
          failed.each do |failed|
            errors.add("Email", "'#{failed}' is an invalid address")
          end
        end
      end
    end
  end
end
