module BruteforceTask::Services
  extend ActiveSupport::Concern

  include ActiveModel::Validations
  include BruteforceTask::Addresses
  include Metasploit::Pro::IpRangeValidation
  include TaskConfig::Workspace

  #
  # CONSTANTS
  #

  SERVICES = [
      'AFP',
      'DB2',
      'FTP',
      'HTTP',
      'HTTPS',
      'MSSQL',
      'MySQL',
      'POP3',
      'Postgres',
      'SMB',
      'SNMP',
      'SSH',
      'Telnet',
      'VNC',
      'WinRM'
  ]
  # Maps {SERVICES} to human-readable descriptions.
  DESCRIPTION_BY_SERVICE = {
      'AFP'               => 'Apple Filing Protocol',
      'DB2'               => 'IBM DB2 database',
      'FTP'               => 'File Transfer Protocol server',
      'HTTP'              => 'HTTP server (basic authentication)',
      'HTTPS'             => 'HTTPS server (basic authentication)',
      'MSSQL'             => 'Microsoft SQL Server database',
      'MySQL'             => 'MySQL database',
      'POP3'              => 'Post Office Protocol v3 server',
      'Postgres'          => 'PostgreSQL database',
      'SMB'               => 'Windows/CIFS server',
      'SNMP'              => 'Simple Network Management Protocol',
      'SSH'               => 'Secure Shell server',
      'Telnet'            => 'Telnet server',
      'VNC'               => 'VNC/RFB server',
      'WinRM'             => 'Windows Remote Management Service'
  }
  LOCKOUT_RISK_BY_SERVICE = {
      'AFP'               => 'low',
      'DB2'               => 'low',
      'FTP'               => 'low',
      'HTTP'              => 'low',
      'HTTPS'             => 'low',
      'MSSQL'             => 'medium',
      'MySQL'             => 'medium',
      'POP3'              => 'medium',
      'Postgres'          => 'low',
      'SMB'               => 'high',
      'SNMP'              => 'low',
      'SSH'               => 'medium',
      'Telnet'            => 'low',
      'VNC'               => 'low', # should be medium?,
      'WinRM'             => 'high'
  }

  included do
    #
    # Validations
    #

    minimum_length = 1

    validates :brute_services,
              :length => {
                  :message => "is too short (minimum is 1 service)",
                  :minimum => minimum_length
              },
              :subset => {
                  :of => SERVICES
              }
  end

  #
  # Instance Methods
  #

  # Services selected for bruteforcing (as opposed to {#prechecked_services} from the
  # {BruteforceTask::Addresses#whitelist})
  def brute_services
    @brute_services ||= prechecked_services
  end

  def brute_services=(brute_services)
    @brute_services = brute_services || prechecked_services
  end

  def self.normalize_brute_services(services)
    service_name_set = Set.new
    return service_name_set if services.blank?
    services.each do |service|
      next unless service.name
      service_name_set.add(service.name.downcase)
    end

    open_service_set = Set.new
    service_by_normalized = {}

    SERVICES.each do |service|
      normalized = service.downcase
      service_by_normalized[normalized] = service
    end

    # This index hunting is a better approach for easily adding more
    # protocols, but ultimately needs a little help from the regex list
    # below.
    service_name_set.each do |service_name|
      case service_name
        when /postgres/
          open_service_set.add 'Postgres'
        when /www/
          open_service_set.add 'HTTP'
        when /cifs|netbios-ssn|microsoft-ds/
          open_service_set.add 'SMB'
        when /tds|ms-sql-s/
          open_service_set.add 'MSSQL'
        when /vmware-auth/
          open_service_set.add 'VMAuthd'
        else # There's a 1-to-1 mapping
          service = service_by_normalized[service_name]

          if service
            open_service_set.add service
          end
      end
    end
    open_service_set
  end

  private

  # Expands any dashed IP range (127.0.0.2-127.0.0.5), since
  # postgres return an error if you try host.addr == "127.0.0.2-127.0.0.5"
  def expand_dashed_ip_ranges(hostlist)
    nested_ips = hostlist.map { |ip_str|
      if ip_str.match /.+-.+/ # if the string contains a dash in the middle
        resolved_addresses = []

        begin # valid dashed IP range, let's walk it
          Rex::Socket::RangeWalker.new(ip_str).each { |ip|
            resolved_addresses << ip
          }
        rescue
          next ip_str # failed rangewalker.new, let someone else handle this
        else
          next resolved_addresses
        end
      end

      ip_str # default back to original input
    }

    ips = nested_ips.flatten

    ips
  end

  # Returns a list of all listening protocols, and if they're on the SERVICES
  # list, adds their service name. This list is used to populate the checkboxes
  # initially.
  def open_services(hostlist)
    if hostlist.empty?
      open_services = SERVICES
    else
      # walk and expand IP addresses here
      expanded_hostlist = expand_dashed_ip_ranges(hostlist)

      services = []
      expanded_hostlist.each do |address|
        if valid_ip_or_range?(address)
          hosts = workspace.hosts.where(address: address)

          hosts.each do |host|
            services << workspace.services.where(state: 'open', host_id: host.id)
          end
        end
      end

      services.flatten!
      open_service_set = BruteforceTask::Services.normalize_brute_services(services)

      # Always add SNMP
      open_service_set.add 'SNMP'

      open_services = open_service_set.sort.to_a
    end

    open_services
  end

  # Services open on the {BruteforceTask::Addresses#whitelist}
  def prechecked_services
    open_services(whitelist)
  end
end