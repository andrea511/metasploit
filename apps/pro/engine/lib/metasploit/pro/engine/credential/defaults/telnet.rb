require 'metasploit/pro/engine/credential/defaults/credential_set'

module Metasploit
  module Pro
    module Engine
      module Credential
        module Defaults

          # This class is responsible for generating `Metasploit::Framework::Credential`s representing
          # the common default credentials for Telnet servers.
          class Telnet < CredentialSet

            # The default usernames to try. Inherit base set from the parent class
            USERNAMES = (CredentialSet::USERNAMES.dup + [
              'Alphanetworks',
              'cisco',
              'pix'
            ]).freeze

            # The default passwords to try. Inherit base set from the parent class
            PASSWORDS = (CredentialSet::PASSWORDS.dup + [
              '100',
              'cisco',
              'sanfran',
              'wrgg15_di524',
              'wrgg19_c_dlwbr_dir300 ',
              'wrgn22_dlwbr_dir615',
              'wrgn23_dlwbr_dir600b',
              'wrgn39_dlob.hans_dir645',
              'wrgn49_dlob_dir600b',
              'wrgnd08_dlob_dir815'
            ]).freeze

            # These are known credential pairs that are defaults for various devices
            KNOWN_COMBINATIONS = [
                ['admin', "<<< %s(un='%s') = %u"], #ScreenOS backdoor from CVE-2015-7755
                ['!root', ''],
                ['adm', ''],
                ['admin', ''],
                ['admin', 'admin'],
                ['admin', 'default'],
                ['admin', 'hello'],
                ['admin', 'P@55w0rd!'],
                ['admin', 'password'],
                ['admin', 'switch'],
                ['Administrator', ''],
                ['Administrator', 'admin'],
                ['Administrator', 'ggdaseuaimhrke'],
                ['ADMN', 'admn'],
                ['Alphanetworks', 'wrgg15_di524'],
                ['bbsd-client', 'changeme2'],
                ['bbsd-client', 'NULL'],
                ['cablecom', 'router'],
                ['cisco', ''],
                ['corecess', 'corecess'],
                ['D-Link', 'D-Link'],
                ['d.e.b.u.g', 'User'],
                ['debug', 'synnet'],
                ['diag', 'switch'],
                ['draytek', '1234'],
                ['echo', 'User'],
                ['GEN1', 'gen1'],
                ['GEN2', 'gen2'],
                ['guest', 'User'],
                ['iclock', 'timely'],
                ['installer', 'installer'],
                ['login', 'admin'],
                ['login', 'password'],
                ['manage', '!manage'],
                ['Manager', ''],
                ['Manager', 'Admin'],
                ['Manager', 'Manager'],
                ['MD110', 'help'],
                ['netopia', 'netopia'],
                ['operator', ''],
                ['recovery', 'recovery'],
                ['root', ''],
                ['root', '1234'],
                ['root', 'admin'],
                ['root', 'admin_1'],
                ['root', 'default'],
                ['root', 'ggdaseuaimhrke'],
                ['root', 'iDirect'],
                ['root', 'pass'],
                ['root', 'root'],
                ['root', 'test'],
                ['root', 'tini'],
                ['security', 'security'],
                ['service', 'smile'],
                ['super', 'super'],
                ['super', 'surt'],
                ['superuser', ''],
                ['superuser', '123456'],
                ['superuser', 'admin'],
                ['support', 'support'],
                ['sysadm', 'Admin'],
                ['sysadm', 'anicust'],
                ['sysadm', 'sysadm'],
                ['target', 'password'],
                ['tech', ''],
                ['tech', 'tech'],
                ['User', ''],
                ['write', 'private']
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
