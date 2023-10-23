module SocialEngineering::EmailsHelper
  def email_attack_type_pairs
    types_array = SocialEngineering::Email::ATTACK_TYPES.map(&:humanize)
    replacements = {
      'File' => 'Attach File'
    }
    types_array.map!{ |t| replacements[t] || t }
    Hash[types_array.zip SocialEngineering::Email::ATTACK_TYPES]
  end

  def email_origin_type_pairs
    types_array = SocialEngineering::Email::ORIGIN_TYPES.map(&:humanize)
    Hash[types_array.zip SocialEngineering::Email::ORIGIN_TYPES]
  end

  def email_editor_type_pairs
    types_array = SocialEngineering::Email::EDITOR_TYPES.map(&:humanize)
    Hash[types_array.zip SocialEngineering::Email::EDITOR_TYPES]
  end

  def add_hash_syntax_highlighting(str)
    str = PP.pp str, ''
    formatters = {
      /\=\>/ => 'color: #870884',            # hash rockets
      /[\s]*"[^\=]+"/ => 'color: #984600',   # keys
      /"[^\>]+"[\s,]*$/ => 'color: #1909AE', # values
      /[,]/ => 'color: #4C4E50',             # commas
      /[\[\]]/ => 'color: #4C4E50'           # brackets
    }
    formatters.each do |pattern, style|
      str.gsub! pattern, "<span style='#{style}'>\\0</span>"
    end
    str.gsub(/[\{\}]/, ' ').gsub(/",/, ',').gsub('=>', ' => ').html_safe
  end
end
