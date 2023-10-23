# This class is useful for parsing Boolean values from a 
# hash (e.g. POST headers), along with a fallback default
# value if nil is given.
module Metasploit::Pro::AttrAccessor::Boolean
  extend ActiveSupport::Concern

  # Matches all values that return true from {#set_default_boolean}
  TRUE_REGEX =  /^(t|1|y)/i

  module ClassMethods
    def boolean_attr_accessor(attribute_name, options={})
      options.assert_valid_keys(:default)

      default = options.fetch(:default)
      default_by_boolean_attribute_name[attribute_name] = default

      instance_variable = "@#{attribute_name}".to_sym

      define_method(attribute_name) do
        unless instance_variable_defined?(instance_variable)
          instance_variable_set(instance_variable, default)
        end

        value = instance_variable_get(instance_variable)

        value
      end

      query_method = "#{attribute_name}?"

      define_method(query_method) do
        send(attribute_name)
      end

      setter = "#{attribute_name}="

      define_method(setter) do |raw_value|
        boolean_value = set_default_boolean(raw_value, default)

        instance_variable_set(instance_variable, boolean_value)
      end
    end

    def default_by_boolean_attribute_name
      @default_by_boolean_attribute_name ||= {}
    end
  end

  #
  # Instance Methods
  #

  # Coerces an arbitrary input value to a boolean, with a fallback
  # for when the value is nil.
  #
  # @param [#to_s] raw_value the value to coerce to a boolean
  # @param [#to_s] default the value to coerce if raw_value is nil
  # @return [Boolean] the boolean evaluation of raw_value
  def set_default_boolean(raw_value, default)
    parseable_value = if raw_value.nil? then default else raw_value end
    !!TRUE_REGEX.match(parseable_value.to_s)
  end
end