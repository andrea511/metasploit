class IpRangeValidator < ActiveModel::EachValidator
  include Metasploit::Pro::IpRangeValidation

  def validate_each(record, attribute, value)
    unless valid_ip_or_range?(value)
      record.errors.add(attribute, 'is an invalid IP range')
    end
  end
end
