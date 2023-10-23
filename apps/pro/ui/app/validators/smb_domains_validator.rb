# Validate SMB Domains
# @see http://support.microsoft.com/kb/909264
# This isn't particularly dangerous, but it can catch typos and periods and slashes.
class SmbDomainsValidator < ActiveModel::EachValidator
  #
  # CONSTANTS
  #

  INVALID_DNS_CHARACTER_REGEXP = /[,~:!@#\$\%^&'`\.\(\)\{\}_]/
  INVALID_NETBIOS_CHARACTER_REGEXP = /[\\\/:*?'"<>\|]/
  SMB_DOMAIN_SEPARATOR_REGEXP = /[\s,]+/

  #
  # Instance Methods
  #

  # Anything not allowed for DNS /or/ NetBIOS is out.
  def validate_each(record, attribute, value)
    string = value.to_s
    smb_domains = string.split(SMB_DOMAIN_SEPARATOR_REGEXP)

    smb_domains.each do |smb_domain|
      # DNS check
      invalid_character = smb_domain[INVALID_DNS_CHARACTER_REGEXP]

      # NetBIOS check
      invalid_character ||= smb_domain[INVALID_NETBIOS_CHARACTER_REGEXP]

      if invalid_character
        error = "includes an invalid SMB Domain character ('#{invalid_character}') in SMB Domain (#{smb_domain})"
        record.errors.add(attribute, error)
      end
    end
  end
end
