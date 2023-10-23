require 'metasploit/pro/engine/credential/defaults/credential_set'

module Metasploit
  module Pro
    module Engine
      module Credential
        module Defaults

          # This class is responsible for generating `Metasploit::Framework::Credential`s representing
          # the common default credentials for SSH servers.
          class SSH < CredentialSet

            # The default usernames to try
            USERNAMES = (CredentialSet::USERNAMES.dup).freeze

            # The default passwords to try
            PASSWORDS = (CredentialSet::PASSWORDS.dup).freeze

            # These are known credential pairs that are defaults for various devices
            KNOWN_COMBINATIONS = [
                ['admin', "<<< %s(un='%s') = %u"], #ScreenOS backdoor from CVE-2015-7755
                ['admin' , 'admin'],
                ['admin' , 'admin123'],
                ['admin' , 'adminpass'],
                ['admin' , 'appliance'],
                ['admin' , 'articon'],
                ['admin' , 'default'],
                ['admin' , 'freenas'],
                ['admin' , 'FreeWRT'],
                ['admin' , 'guest'],
                ['admin' , 'jetNEXUS'],
                ['admin' , 'orbital'],
                ['ADMIN' , 'PASSWORD'],
                ['admin' , 'password'],
                ['admin' , 'pfsense'],
                ['admin' , 'raritan'],
                ['admin' , 'setup'],
                ['admin' , 'symantec'],
                ['admin' , 'TANDBERG'],
                ['admin' , 'wanscaler'],
                ['admn' , 'admn'],
                ['apc' , 'apc'],
                ['avniuadm' , 'r8nd0m'],
                ['catadm' , 'catadm'],
                ['customer' , 'netoptics'],
                ['default' , ''],
                ['device' , 'apc'],
                ['dominion' , ''],
                ['downloader' , 'downloader'],
                ['guest' , 'guest'],
                ['hscroot' , 'abc123'],
                ['InReach' , 'access'],
                ['IQMANAGER' , 'IQ'],
                ['login' , 'access'],
                ['lp' , 'lp'],
                ['manager' , 'friend'],
                ['menu' , 'cymphonix'],
                ['nobody' , ''],
                ['pix' , 'cisco'],
                ['radware' , 'radware'],
                ['root' , '0000'],
                ['root' , '12xerXes06'],
                ['root' , 'admin'],
                ['root' , 'alpine'],
                ['root' , 'baytech'],
                ['root' , 'calvin'],
                ['root' , 'cisco123'],
                ['root' , 'dbps'],
                ['root' , 'default'],
                ['root' , 'dottie'],
                ['root' , 'ispadmin'],
                ['root' , 'nbox'],
                ['root' , 'opeNSLUg'],
                ['root' , 'pass'],
                ['root' , 'password'],
                ['root' , 'password'],
                ['root' , 'qwert'],
                ['root' , 'rootme'],
                ['root' , 'system'],
                ['root' , 'tslinux'],
                ['root' , 'uClinux'],
                ['root' , 'vertex25'],
                ['root' , 'vicidialnow'],
                ['root' , 'vyatta'],
                ['root' , 'wyse'],
                ['root' , 'yoggie'],
                ['security' , 'transfer'],
                ['service' , 'sm1l3'],
                ['service' , 'smile'],
                ['sheer' , 'sheer'],
                ['snwlcli' , 'password'],
                ['spam' , 'password'],
                ['sshadmin' , 'simplenet'],
                ['Superuser' , 'system'],
                ['tda' , ''],
                ['tda' , 'admin'],
                ['user' , 'user']
            ].freeze

            # 2-dimensional array containing all combinations of {USERNAMES} and {PASSWORDS}
            COMBINATIONS = (USERNAMES.product(PASSWORDS) + KNOWN_COMBINATIONS).uniq.freeze

            # A count of all the combinations held in {COMBINATIONS}
            COUNT = COMBINATIONS.count.freeze

          end
        end
      end
    end
  end
end
