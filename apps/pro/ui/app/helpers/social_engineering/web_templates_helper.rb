module SocialEngineering::WebTemplatesHelper
  def web_template_origin_type_pairs
    types_array = SocialEngineering::WebTemplate::ORIGIN_TYPES.map(&:humanize)
    replace = {
      'clone' => 'Clone URL'
    }
    types_array.map!{ |t| replace[t] || t }
    Hash[types_array.zip SocialEngineering::WebTemplate::ORIGIN_TYPES]
  end
end