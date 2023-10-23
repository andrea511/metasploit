module SocialEngineering::WebPage::Content
  extend ActiveSupport::Concern

  #
  # CONSTANTS
  #

  DEFAULT_CONTENT = <<-eos
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
</head>
<body>

</body>
</html>
eos

  included do
    #
    # Validations
    #

    validates :content, :presence => true, :unless => :file_attack?
    validate :content_has_a_form
  end

  #
  # Instance Methods
  #

  def custom_attributes
    unless @custom_attributes.present?
      @custom_attributes = SocialEngineering::Email.liquid_drops_select_list_pairs

      if not campaign.uses_wizard? and other_web_pages.present?
        @custom_attributes << ['Link to Web Page', 'campaign_link']
      end
    end

    @custom_attributes
  end

  attr_accessor :insert

  private

  def content_has_a_form
    doc = Nokogiri::HTML self.content
    if phishing_attack?
      unless doc.search("form").any?
        errors.add(:content, " must have a form")
      end
    end
  end
end