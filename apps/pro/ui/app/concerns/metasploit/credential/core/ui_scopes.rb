# Adds some scopes that are useful from the UI

module Metasploit::Credential::Core::UiScopes
  extend ActiveSupport::Concern

  included do
    include TableResponder::UiScopes


    # @return [String] a key version of the private type for building option menus
    def type_key
      case private
        when NilClass
          'none'
        when Metasploit::Credential::SSHKey
          'ssh'
        when Metasploit::Credential::PasswordHash || Metasploit::Credential::ReplayableHash
          'hash'
        when Metasploit::Credential::NTLMHash
          'ntlm'
        when Metasploit::Credential::Password
          'plaintext'
      end
    end

  end

end
