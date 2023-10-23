class SocialEngineering::WebPage < ApplicationRecord
  include SocialEngineering::WebPage::AttackType
  include SocialEngineering::WebPage::Content
  include SocialEngineering::WebPage::Path
  include SocialEngineering::WebPage::OriginType

  self.table_name = :se_web_pages

  #
  # CONSTANTS
  #

  DEFAULT_USER_AGENT = 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)'
  WEB_PAGE_TITLE = 'Configure Web Page'

  #
  # Associations - order by name
  #

  belongs_to :campaign, :class_name => 'SocialEngineering::Campaign', :touch => true
  has_many :visits, :class_name => 'SocialEngineering::Visit'
  has_many :phishing_results, :class_name => 'SocialEngineering::PhishingResult'
  belongs_to :template, :class_name => 'SocialEngineering::WebTemplate', optional: true #wizard does not always have a template

  #
  # Serializations
  #

  serialize :prefs # TODO: Change to JSON

  #
  # Validations - sorted by attribute name
  #

  validates :campaign, :presence => true
  validates :name, :presence => true, :uniqueness => { :scope => :campaign_id }
  validates :save_form_data, inclusion: { in: [true, false] }

  #
  # Scopes
  #
  
  scope :campaign_id, lambda {|campaign_id| where(:campaign_id => campaign_id)}

  #
  # Methods - sorted by name
  #

  # @return [Boolean] whether or not we have unsatisfied refs (e.g. reference to a redirect page)
  def configured?
    !phishing_attack? || phishing_redirect_url.present?
  end

  def other_web_pages
    @other_web_pages ||= SocialEngineering::WebPage.where(campaign_id: self.campaign.id) - [self]
  end

  def render_page_in_template
    if template.present?
      template.render_with_web_page(self) 
    else
      self.content
    end
  end

  def drop_form_data
    noko = Nokogiri::HTML(self.content)
    noko.css("form").each do |form|
      form.css("input").each do |input|
        unless input.attributes["name"].nil?
          # Removing the 'name' attribute from <input> tags is an easy,
          # non-js way to have the target's browser drop the data before it
          # ever hits the wire.  See MS-1783.
          input.remove_attribute("name")
        end
      end
    end
    noko.to_s
  end

  def to_hash
    {
      name: name,
      type: 'web_page',
      attack_type: attack_type.humanize,
      phishing_redirect_origin: phishing_redirect_origin,
      status: 'N/A',
      id: id,
      save_form_data: save_form_data
    }
  end

  def url
    host = campaign.web_host
    port = if attack_type == 'bap' then campaign.web_bap_port else campaign.web_port end
    uses_ssl = campaign.web_ssl
  
    if uses_ssl
      if port == 443
        port_str = ''
      else
        port_str = ":#{port}"
      end
    else
      if port == 80
        port_str = ''
      else
        port_str = ":#{port}"
      end
    end

    protocol = if uses_ssl then 'https://' else 'http://' end

    "#{protocol}#{host}#{port_str}#{path}"
  end
end
