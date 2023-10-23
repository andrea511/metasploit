module SocialEngineering
class PhishingWebContent
  attr_reader :raw_content, :doc

  def initialize(raw_content)
    @raw_content = raw_content
    @doc = Nokogiri::HTML::Document.parse(raw_content)
  end

  # Make all form action attributes blank
  def delete_form_actions!
    doc.css('form').map do |f|
      f['action'] = ""
    end
  end

  # Make all form method attributes POST
  def convert_form_methods_to_post!
    doc.css('form').map do |f|
      f['method'] = "POST"
    end
  end
  
end
end
