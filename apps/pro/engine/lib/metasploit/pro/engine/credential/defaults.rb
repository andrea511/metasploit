require 'metasploit/pro/engine/credential/defaults/credential_set'
require 'metasploit/pro/engine/credential/defaults/axis2'
require 'metasploit/pro/engine/credential/defaults/db2'
require 'metasploit/pro/engine/credential/defaults/ftp'
require 'metasploit/pro/engine/credential/defaults/http'
require 'metasploit/pro/engine/credential/defaults/mssql'
require 'metasploit/pro/engine/credential/defaults/mysql'
require 'metasploit/pro/engine/credential/defaults/postgres'
require 'metasploit/pro/engine/credential/defaults/smb'
require 'metasploit/pro/engine/credential/defaults/snmp'
require 'metasploit/pro/engine/credential/defaults/ssh'
require 'metasploit/pro/engine/credential/defaults/telnet'
require 'metasploit/pro/engine/credential/defaults/tomcat'
require 'metasploit/pro/engine/credential/defaults/vnc'
require 'metasploit/pro/engine/credential/defaults/winrm'

module Metasploit
  module Pro
    module Engine
      module Credential

        # This module provides the namepsace for all the default Credential Set Classes.
        # It also provides a few methods for finding the right default class for a given `Mdm::Service`
        module Defaults

          # This method returns the class of a Defaults CredentialSet to use for a given service
          # or else returns nil.
          #
          # @param [Mdm::Service] the service to find the right credential set for
          # @return [Class] if we found an appropriate class
          # @return [nil]  if we did not find an appropriate class
          def self.class_for_service(service)
            raise ArgumentError, "Must be an Mdm::Service" unless service.kind_of? Mdm::Service

            case service.name
              when 'db2'
                Metasploit::Pro::Engine::Credential::Defaults::DB2
              when 'ftp'
                Metasploit::Pro::Engine::Credential::Defaults::FTP
              when /http(s)*/
                case service.info
                  when /Tomcat|Coyote/
                    Metasploit::Pro::Engine::Credential::Defaults::Tomcat
                  when /Axis/
                    Metasploit::Pro::Engine::Credential::Defaults::Axis2
                  else
                    Metasploit::Pro::Engine::Credential::Defaults::HTTP
                end
              when 'mssql'
                Metasploit::Pro::Engine::Credential::Defaults::MSSQL
              when 'mysql'
                Metasploit::Pro::Engine::Credential::Defaults::MYSQL
              when 'postgres'
                Metasploit::Pro::Engine::Credential::Defaults::Postgres
              when 'smb'
                Metasploit::Pro::Engine::Credential::Defaults::SMB
              when 'snmp'
                Metasploit::Pro::Engine::Credential::Defaults::SNMP
              when 'ssh'
                Metasploit::Pro::Engine::Credential::Defaults::SSH
              when 'telnet'
                Metasploit::Pro::Engine::Credential::Defaults::Telnet
              when 'winrm'
                Metasploit::Pro::Engine::Credential::Defaults::WINRM
              else
                return nil
            end
          end

          # This method takes a group of services, and determines how many default credentials
          # would be tried for all of those services.
          #
          # @param [Array<Mdm::Service>] the group of services to get a count for
          # @return [Integer] the number of credentials that would be tried
          def self.count_for_services(services)
            default_count = 0
            services.each do |service|
              this_class = class_for_service(service)
              unless this_class.nil?
                count_this_service = this_class::COUNT
                default_count += count_this_service
              end
            end
            default_count
          end

          # This method takes a `Mdm::Service` and returns a {CredentialSet} that is appropriate
          # for that service. If one cannot be found, it returns an empty array instead.
          #
          # @param [Mdm::Service] the service to find the default credentials for
          # @return [CredentialSet] if a default credential set was found
          # @return [Array] if no credential set was found
          def self.default_creds_for_service(service)
            default_class = class_for_service(service)
            if default_class.nil?
              []
            else
              default_class.new
            end
          end

          def self.wordlist
            words = Set.new
            self.constants.each do |credential_set|
              class_name = "#{self}::#{credential_set}"
              words += class_name.constantize::PASSWORDS
            end
            words
          end


        end
      end
    end
  end
end
