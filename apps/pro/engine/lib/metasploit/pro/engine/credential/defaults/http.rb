require 'metasploit/pro/engine/credential/defaults/credential_set'

module Metasploit
  module Pro
    module Engine
      module Credential
        module Defaults

          # This class is responsible for generating `Metasploit::Framework::Credential`s representing
          # the common default credentials for HTTP servers.
          class HTTP < CredentialSet

            # The default usernames to try
            USERNAMES = [
              'admin',
              'apc',
              'cisco',
              'connect',
              'manager',
              'newuser',
              'pass',
              'private',
              'root',
              'security',
              'sitecom',
              'sys',
              'system',
              'tomcat',
              'user',
              'wampp',
              'xampp',
              'xampp-dav-unsecure'
            ].freeze

            # The default passwords to try
            PASSWORDS = [
              '1234',
              'admin',
              'apc',
              'axis2',
              'cisco',
              'connect',
              'default',
              'letmein',
              'manager',
              'none',
              'pass',
              'password',
              'ppmax2011',
              'root',
              'sanfran',
              'security',
              'sitecom',
              'sys',
              'system',
              'tomcat',
              'turnkey',
              'user',
              'wampp',
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
