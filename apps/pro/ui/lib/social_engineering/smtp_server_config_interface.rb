module SocialEngineering::SmtpServerConfigInterface
  extend ActiveSupport::Concern

  include SocialEngineering::Port

  #
  # CONSTANTS
  #

  SMTP_AUTH_TYPES = ['plain', 'login', 'cram_md5']
  SMTP_AUTH_TYPE_SENTENCE = SMTP_AUTH_TYPES.to_sentence(
      :last_word_connector => ', or ',
      :two_words_connector => ' or '
  )
  SMTP_BATCH_SIZE  = 20
  SMTP_BATCH_DELAY = 300

  included do
    ancestor = ApplicationRecord

    unless ancestors.include? ancestor
      raise "must be included by #{ancestor} descendent"
    end

    extend MetasploitDataModels::SerializedPrefs

    #
    # Serialized Preferences - ordered by name
    #

    serialized_prefs_attr_accessor :smtp_auth
    serialized_prefs_attr_accessor :smtp_config_saved
    serialized_prefs_attr_accessor :smtp_domain
    serialized_prefs_attr_accessor :smtp_host
    serialized_prefs_attr_accessor :smtp_password
    serialized_prefs_attr_accessor :smtp_port
    serialized_prefs_attr_accessor :smtp_ssl
    serialized_prefs_attr_accessor :smtp_username
    serialized_prefs_attr_accessor :smtp_batch_size
    serialized_prefs_attr_accessor :smtp_batch_delay

    #
    # Validations
    #

    validates_port :smtp
    validates :smtp_batch_size, :numericality => {:greater_than_or_equal_to => 1}
    validates :smtp_batch_delay, :numericality => {:greater_than_or_equal_to => 0}
    validates :smtp_auth,
              :inclusion => {
                  :in => SMTP_AUTH_TYPES,
                  :message => "must be #{SMTP_AUTH_TYPE_SENTENCE}"
              }

  end

  #
  # Instance Methods - ordered by name
  #

  def smtp_configured?
    smtp_host.present? && smtp_port.present? && smtp_config_saved
  end
end

