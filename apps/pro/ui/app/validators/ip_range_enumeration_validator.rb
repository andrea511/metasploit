class IpRangeEnumerationValidator < ActiveModel::EachValidator
  include Metasploit::Pro::IpRangeValidation

  def validate_each(record, attribute, value)
    if value.respond_to? :each
      value.each do |ip|
        unless valid_ip_or_range?(ip)
          record.errors.add(attribute, "includes invalid IP range: #{ip}")
        end
      end
    end
  end
end
