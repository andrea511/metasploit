module BruteforceTask::Addresses
  extend ActiveSupport::Concern

  include ActiveModel::Validations
  include Metasploit::Pro::AttrAccessor::Addresses

  included do
    #
    # Addresses
    #

    addresses_attr_accessor :blacklist
    addresses_attr_accessor :whitelist

    #
    # Validations
    #

    validates :whitelist,
              :length => {
                  :minimum => 1,
                  :message => 'is too short (minimum is 1 address)'
              }
    validates :whitelist_string, :boundary => true
  end

  def whitelist_string
    whitelist.join("\n")
  end

  def blacklist_string
    blacklist.join("\n")
  end
end