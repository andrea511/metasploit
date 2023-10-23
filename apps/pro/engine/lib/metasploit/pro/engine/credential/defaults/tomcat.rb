require 'metasploit/pro/engine/credential/defaults/credential_set'

module Metasploit
  module Pro
    module Engine
      module Credential
        module Defaults

          # This class is responsible for generating `Metasploit::Framework::Credential`s representing
          # the common default credentials for Tomcat servers.
          class Tomcat < CredentialSet

            # The default usernames to try
            USERNAMES = [
              'admin',
              'both',
              'cxsdk',
              'j2deployer',
              'manager',
              'ovwebusr',
              'role1',
              'root',
              'tomcat',
              'xampp'
            ].freeze

            # The default passwords to try
            PASSWORDS = [
              'admin',
              'j2deployer',
              'kdsxc',
              'manager',
              'OvW*busr1',
              'owaspbwa',
              'role1',
              'root',
              's3cret',
              'tomcat',
              'xampp'
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
