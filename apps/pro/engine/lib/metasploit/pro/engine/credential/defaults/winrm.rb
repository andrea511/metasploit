require 'metasploit/pro/engine/credential/defaults/credential_set'

module Metasploit
  module Pro
    module Engine
      module Credential
        module Defaults

          # This class is responsible for generating `Metasploit::Framework::Credential`s representing
          # the common default credentials for WinRM servers.
          class WINRM < SMB

            #These are all just windows system accounts so we inherit everything from SMB right now
          end
        end
      end
    end
  end
end
