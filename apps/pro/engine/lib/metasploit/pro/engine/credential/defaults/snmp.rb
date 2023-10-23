require 'metasploit/pro/engine/credential/defaults/credential_set'

module Metasploit
  module Pro
    module Engine
      module Credential
        module Defaults

          # This class is responsible for generating `Metasploit::Framework::Credential`s representing
          # the common default credentials for SNMP servers.
          class SNMP < CredentialSet

            # The default usernames to try
            USERNAMES = [
              ''
            ].freeze

            # The default passwords to try
            PASSWORDS = [
              '0',
              '0392a0',
              '1234',
              '2read',
              '4changes',
              'access',
              'adm',
              'Admin',
              'admin',
              'agent',
              'agent_steal',
              'all',
              'all private',
              'all public',
              'ANYCOM',
              'apc',
              'bintec',
              'blue',
              'c',
              'C0de',
              'cable-d',
              'canon_admin',
              'cc',
              'CISCO',
              'cisco',
              'community',
              'core',
              'CR52401',
              'debug',
              'default',
              'dilbert',
              'enable',
              'field',
              'field-service',
              'freekevin',
              'fubar',
              'guest',
              'hello',
              'hp_admin',
              'IBM',
              'ibm',
              'ILMI',
              'ilmi',
              'Intermec',
              'intermec',
              'internal',
              'l2',
              'l3',
              'manager',
              'mngt',
              'monitor',
              'netman',
              'network',
              'NoGaH$@!',
              'none',
              'openview',
              'OrigEquipMfr',
              'pass',
              'password',
              'pr1v4t3',
              'private',
              'PRIVATE',
              'Private',
              'proxy',
              'publ1c',
              'public',
              'PUBLIC',
              'Public',
              'read',
              'read-only',
              'read-write',
              'readwrite',
              'red',
              'regional',
              'rmon',
              'rmon_admin',
              'ro',
              'root',
              'router',
              'rw',
              'rwa',
              's!a@m#n$p%c',
              'san-fran',
              'sanfran',
              'scotty',
              'SECRET',
              'Secret',
              'secret',
              'SECURITY',
              'Security',
              'security',
              'seri',
              'SNMP',
              'snmp',
              'SNMP_trap',
              'snmpd',
              'snmptrap',
              'solaris',
              'SUN',
              'sun',
              'superuser',
              'SWITCH',
              'Switch',
              'switch',
              'SYSTEM',
              'System',
              'system',
              'tech',
              'TENmanUFactOryPOWER',
              'TEST',
              'test',
              'test2',
              'tiv0li',
              'tivoli',
              'trap',
              'world',
              'write',
              'xyzzy',
              'yellow'
            ].freeze

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
