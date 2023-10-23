module Metasploit::Pro::AttrAccessor::Integer
  extend ActiveSupport::Concern

  module ClassMethods
    def integer_attr_accessor(attribute_name)
      integer_attribute_name_set.add(attribute_name)

      instance_variable = "@#{attribute_name}".to_sym

      define_method(attribute_name) do
        value = instance_variable_get(instance_variable)

        unless value
          value = 0
          instance_variable_set(instance_variable, value)
        end

        value
      end

      setter = "#{attribute_name}="

      define_method(setter) do |raw_value|
        castable_value = raw_value || 0
        value = castable_value.to_i

        instance_variable_set(instance_variable, value)
      end
    end

    def integer_attribute_name_set
      @integer_attribute_name_set ||= Set.new
    end
  end
end