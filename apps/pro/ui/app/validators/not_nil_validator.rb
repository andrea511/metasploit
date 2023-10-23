# Differs from PresenceValidator is that the {NotNilValidator} will alllow blanks (`''`), but not `nil` while
# PresenceValidator won't allow either.
class NotNilValidator < ActiveModel::EachValidator
  # Validates each attribute and record an error against the attribute if value is `nil?`.
  #
  # @param record [ActiveModel::Validations] an ActiveModel or ActiveRecord
  # @param attribute []
  # @return[void]
  def validate_each(record, attribute, value)
    if value.nil?
      record.errors.add(attribute, "cannot be nil, but can be blank ('')")
    end
  end
end
