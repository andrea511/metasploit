# Provide classification information useful to both sides of the MSPro RPC bridge
# when creating Msf/Mdm Session objects via login (as opposed to exploitation).
#
# Not all TCP services (represented by Mdm::Service objects) that provide a notion of authentication
# can provide a command shell. This module provides information used to compute which services/payloads
# can be used in gaining interactive sessions through authentication.
module Mdm::Service::Shellable
  extend ActiveSupport::Concern

  included do
    # Values for {Mdm::Service#name} that can be used to initiate a login-based shell
    SHELLABLE_SERVICE_NAMES = %w(http mssql mysql postgres smb ssh telnet winrm)

    # Indicates when Service will require a certain family of payload.
    # Keys should be one of {AVAILABLE_SHELL_SERVICE_NAMES}
    # Values should be one of 'cmd' or 'meterpreter'
    SHELLABLE_SERVICES_MANDATORY_PAYLOAD_TYPES = {
      'http'     => nil,
      'mssql'    => nil,
      'mysql'    => nil,
      'postgres' => nil,
      'smb'      => 'meterpreter',
      'ssh'      => nil,
      'telnet'   => nil,
      'winrm'    => 'meterpreter',
    }

    # Returns a value appropriate for Pro's PAYLOAD_TYPE which is a key used in {Metasploit3#datastore} objects
    # to specify the basic type of payload that should be used with the module.
    # @param sname [String]
    # @return [String]
    def self.required_payload_type_for_service_name(sname)
      fail "'#{sname}' is service that can provide a login shell" unless ::Mdm::Service::SHELLABLE_SERVICE_NAMES.include? sname
      ::Mdm::Service::SHELLABLE_SERVICES_MANDATORY_PAYLOAD_TYPES[sname]
    end
  end


end