class MacroNameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    string = value.to_s

    unless Mdm::Macro.where(:name => string).exists?
      record.errors.add(attribute, 'is not the name of an existing macro')
    end
  end
end
