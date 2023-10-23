class UsableValidator < ActiveModel::EachValidator
  def check_validity!
    unless options.has_key? :by
      raise ArgumentError, 'the attribute name of the argument to usable_by? must be passed to the :by option'
    end
  end

  def validate_each(record, attribute, value)
    if value
      user_attribute_name = options[:by]
      user = record.send(user_attribute_name)

      unless value.usable_by?(user)
        record.errors.add(attribute, "is not usable by #{user_attribute_name} (#{user})")
      end
    end
  end
end
