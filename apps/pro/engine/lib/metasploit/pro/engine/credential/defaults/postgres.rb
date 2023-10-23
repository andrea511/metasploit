require 'metasploit/pro/engine/credential/defaults/credential_set'

module Metasploit
  module Pro
    module Engine
      module Credential
        module Defaults

          # This class is responsible for generating `Metasploit::Framework::Credential`s representing
          # the common default credentials for Postgres servers.
          class Postgres < CredentialSet

            # The default usernames to try
            USERNAMES = [
              'admin',
              'postgres',
              'scott',
              'tom',
            ].freeze

            # The default passwords to try
            PASSWORDS = [
              'admin',
              'password',
              'postgres',
              'tiger'
            ].freeze

            # 2-dimensional array containing all combinations of {USERNAMES} and {PASSWORDS}
            COMBINATIONS = USERNAMES.product(PASSWORDS).uniq.freeze

            # A count of all the combinations held in {COMBINATIONS}
            COUNT = COMBINATIONS.count.freeze

          end
        end
      end
    end
  end
end
