class SocialEngineering::Email < ApplicationRecord
  include LiquidTemplating::Powers
  include SocialEngineering::EmailAttackConfigInterface

  self.table_name = :se_emails

  #
  # CONSTANTS
  #

  ATTACK_TYPES = ['none', 'file']
  # we favor the rich text editor as the default UI choice
  EDITOR_TYPES = ['rich_text', 'plain_text', 'preview']
  ORIGIN_TYPES = ['custom', 'template']
  PHISHING_DEFAULTS = {
    :name => 'E-mail',
    :subject => 'URGENT: Reset your intranet password',
    :from_address => 'security@yourcompany.com',
    :from_name => 'IT Security',
    :content => <<-eos
<p>{{first_name}},</p>
<p>We have increased our password requirements for security purposes. 
Please use the link below within 24 hours to maintain access to your account.</p>
<p><a href="{% campaign_href 'Landing Page' %}">Click here</a></p>
<p>Thank you,</p>
<p>The IT Support Staff</p>
<p><small>This email was intended for {{first_name}} {{last_name}}.</small></p>
eos
  }
  VALID_FILE_GENERATION_TYPES = ['exe_agent', 'file_format']

  #
  # Associations - sorted by association name
  #

  belongs_to :campaign, :class_name => 'SocialEngineering::Campaign', :touch => true
  has_many :email_openings, :class_name => 'SocialEngineering::EmailOpening'
  has_many :email_sends, :class_name => 'SocialEngineering::EmailSend'
  has_many :files, :as => :attachable, :class_name => 'SocialEngineering::CampaignFile'
  belongs_to :target_list, :class_name => 'SocialEngineering::TargetList'
  belongs_to :template, :class_name => 'SocialEngineering::EmailTemplate', :foreign_key => :email_template_id, optional: true # explicitly defined to allow custom type
  belongs_to :user, :class_name => 'Mdm::User', optional: true # another location where Users has never really been applied
  has_many :visits, :class_name => 'SocialEngineering::Visit'
  has_many :trackings, :class_name => 'SocialEngineering::Tracking', :dependent => :destroy

  #
  # Callbacks
  #

  before_save :autoset_origin_type

  #
  # Liquid
  #

  liquid_template :content
  liquid_drops SocialEngineering::HumanTarget, :first_name, :last_name, :email_address

  #
  # Serializations
  #

  serialize :prefs # TODO: use JSON to serialize after upgrading to Rails 3.2.5

  #
  # Validations
  #

  validates :attack_type, :inclusion => { :in => ATTACK_TYPES }
  validates :campaign, :presence => true
  validates :content, :presence => true
  validates :name, :presence => true
  validates :origin_type, :inclusion => { :in => ORIGIN_TYPES }
  validates :target_list, :presence => true
  validates :exclude_tracking,
            inclusion: { in: [true, false] }
  #
  # Scopes
  #

  scope :retrieve_for_process,
    lambda{ |email_id|
      where(:id => email_id).includes(:target_list => :human_targets)
    }

  scope :campaign_id, lambda {|campaign_id| where(:campaign_id => campaign_id)}

  #
  # Custom accessors. Used as placeholders for the UI, since formastic requires
  #   an attribute to build a field.
  #
  attr_accessor :insert
  attr_accessor :phishing_redirect

  def custom_attributes
    unless @custom_attributes.present?
      @custom_attributes = SocialEngineering::Email.liquid_drops_select_list_pairs
      if other_web_pages.present? && !campaign.uses_wizard?
        @custom_attributes << ['Link to Web Page', 'campaign_link']
      end
      if campaign && campaign.uses_wizard?
        @custom_attributes << ['Link to Landing Page', 'campaign_landing_link']
      end
    end
    @custom_attributes
  end

  def other_web_pages
    @other_web_pages ||= SocialEngineering::WebPage.where(campaign_id: self.campaign.id)
  end

  # Render an email with template, using human_target as the "drop
  # object" that carries data for placeholders in Email#content
  def render_body_for_send(human_target, tracking=true)

    if uses_template? # pass human_target & campaign back up to template
      text = template.render_with_email_content liquid_render_with_drop_object(human_target, tracking), human_target
    else
      text = liquid_render_with_drop_object(human_target, tracking)
    end

    text.strip!
    unless text.match(/\A<html>.*?<body>.*?<\/body>.*?<\/html>\z/im) # Something is missing. Lets make sure both body and html tags are present

      if text.match(/\A<html>.*?<\/html>\z/im) # body tags were forgotten. Lets add them.
        text = text.gsub(/<html>\s*?/i,"<html>\r\n<body>\r\n").gsub(/<\/html>/i,"\r\n</body>\r\n</html>")
      elsif text.match(/\A<body>.*?<\/body>\z/im) # body tags are there, so HTML tags must be missing.
        text = "<html>\r\n#{text}\r\n</html>"
      else
        text = "<html>\r\n<body>\r\n#{text}\r\n</body>\r\n</html>" # both body and html tags were omitted.
      end
    end
    text
  end

  def target_list_name
    if target_list.present?
      target_list.name
    else
      ''
    end
  end

  def target_list_remaining
    if target_list.present?
      # Interpolation, but of a safe value and this fsking method doesn't parameterize (as of Rails 4.2)
      target_list.human_targets.
        joins("LEFT JOIN se_email_sends ON se_email_sends.human_target_id = se_human_targets.id AND se_email_sends.email_id = #{self.class.connection.quote id}").
        where(se_email_sends: {sent: [false, nil]})
    else
      TargetList.none
    end
  end

  def target_list_size
    if target_list.present?
      target_list.human_targets.count
    else
      0
    end
  end

  def to_hash
    {
      name: name,
      type: 'email',
      attack_type: attack_type.humanize,
      status: 'N/A',
      target_list_name: target_list_name,
      id: id
    }
  end

  def uses_template?
    origin_type == 'template'
  end

  private

  def autoset_origin_type
    self.origin_type = if template.present? then 'template' else 'custom' end
  end
end
