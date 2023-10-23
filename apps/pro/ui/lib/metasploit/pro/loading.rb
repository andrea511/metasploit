module Metasploit::Pro::Loading
  def self.constantize_pathname(descendent_pathname, options={})
    constant_name = pathname_to_constant_name(descendent_pathname, options)

    constant = nil

    if constant_name
      constant = constant_name.constantize
    end

    constant
  end

  def self.each_pathname_constant(parent_pathname, options={})
    parent_pathname.each_child do |child_pathname|
      constant = constantize_pathname(child_pathname, options)

      if constant
        yield constant
      end
    end
  end

  def self.pathname_to_constant_name(descendent_pathname, options={})
    options.assert_valid_keys(:relative_to)
    ancestor_pathname = options.fetch(:relative_to)

    extension_name = descendent_pathname.extname

    constant_name = nil

    if extension_name == '.rb'
      constant_pathname = descendent_pathname.relative_path_from(ancestor_pathname)
      constant_name = constant_pathname.to_s.gsub(/.rb$/, '').camelize
    end

    constant_name
  end
end