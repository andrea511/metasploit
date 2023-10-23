require 'metasploit/pro/engine/credential/defaults/credential_set'

module Metasploit
  module Pro
    module Engine
      module Credential
        module Defaults

          # This class is responsible for generating `Metasploit::Framework::Credential`s representing
          # the common default credentials for VNC servers.
          class VNC < CredentialSet

            # The default usernames to try
            USERNAMES = [
              ''
            ].freeze

            PASSWORDS = (CredentialSet::PASSWORDS.dup + [
              '100',
            ]).freeze

            # 2-dimensional array containing all combinations of {USERNAMES} and {PASSWORDS}
            COMBINATIONS = USERNAMES.product(PASSWORDS).uniq.freeze

            # A count of all the combinations held in {COMBINATIONS}
            COUNT = COMBINATIONS.count.freeze

            # Whether the credential requires both a Public and Private to be valid
            PAIRED = false

          end
        end
      end
    end
  end
end
