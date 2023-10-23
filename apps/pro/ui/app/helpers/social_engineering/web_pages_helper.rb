module SocialEngineering::WebPagesHelper
  def web_page_attack_type_pairs
    types_array = SocialEngineering::WebPage::ATTACK_TYPES.map(&:humanize)
    replacements = {
      'File' => 'Serve File',
      'Bap'  => 'Browser Autopwn',
      'Java signed applet' => 'Java Signed Applet'
    }
    types_array.map!{ |t| replacements[t] || t }
    Hash[types_array.zip SocialEngineering::WebPage::ATTACK_TYPES]
  end

  def web_page_origin_type_pairs
    types_array = SocialEngineering::WebPage::ORIGIN_TYPES.map(&:humanize)
    replacements = {
      'Clone' => 'Clone URL'
    }
    types_array.map!{ |t| replacements[t] || t }
    Hash[types_array.zip SocialEngineering::WebPage::ORIGIN_TYPES]
  end

  def web_page_file_generation_type_pairs
    types_array = SocialEngineering::WebPage::VALID_FILE_GENERATION_TYPES.map(&:humanize)
    replacements = {
      'Exe agent' => '.exe agent',
      'File format' => 'File format exploit',
      'User supplied' => 'User supplied file'
    }
    types_array.map!{ |t| replacements[t] || t }
    Hash[types_array.zip SocialEngineering::WebPage::VALID_FILE_GENERATION_TYPES]
  end

  def current_file
    if @web_page.files.present?
      @web_page.files.first.to_s
    else
      ''
    end
  end

  def inject_script(content, script)
    end_body_regex = /<\/head>/imx
    if content =~ end_body_regex
      content.gsub(end_body_regex, "#{script}</head>")
    else
      content
    end
  end
end

