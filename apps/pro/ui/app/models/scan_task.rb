require 'ipaddr'

class ScanTask < TaskConfig
  PORTSCAN_SPEED_LABELS = [ "Paranoid", "Sneaky", "Polite", "Normal", "Aggressive", "Insane" ]
  PORTSCAN_SPEEDS       = (0..PORTSCAN_SPEED_LABELS.size).to_a

  # @!attribute [r] addresses
  #   @return [Array<String>] strings containing addresses, hostnames, ranges, or tags
  attr_reader :addresses

  # @!attribute [rw] address_string, submitted by the user
  # This value is split into the #addresses array by #initialize
  #   @return [String]
  attr_accessor :address_string

  # Blacklist IPs
  attr_accessor :blacklist

  # Custom nmap
  attr_accessor :custom_nmap

  # 0 (slow) - 5 (fast)
  attr_accessor :portscan_speed

  # maxiumum number of minutes to spend on one target before moving on
  attr_accessor :portscan_timeout

  # an optional source port for the scan
  attr_accessor :portscan_source_port

  attr_accessor :ports_extra, :ports_blacklist, :ports_custom

  attr_accessor :udp_probes, :finger_users, :snmp_scan, :h323_scan, :identify_services, :dry_run, :single_scan, :fast_detect

  attr_accessor :smb_username, :smb_password, :smb_domain

  attr_accessor :autotag_os

  attr_accessor :initial_nmap
  attr_accessor :initial_webscan

  attr_accessor :webscan_max_pages, :webscan_max_minutes, :webscan_max_threads
  attr_accessor :http_username, :http_password, :http_domain, :cookie, :user_agent

  # skips the validation for IP addresses passed in
  attr_accessor :skip_host_validity_check

  attr_accessor :skipped_hosts

  # @param [Hash] attributes the options hash
  # @option attributes [String]        :address_string a string of address ranges to scan
  # @option attributes [Array<String>] :addresses an array of address ranges to scan
  def initialize(attributes)
    super(attributes)

    @addresses = []

    if attributes[:addresses].present?
      @addresses += tags_and_addresses(attributes[:addresses])
    end
    if attributes[:address_string].present?
      @addresses += tags_and_addresses(attributes[:address_string].split(/\s+/))
    end

    # we precalculate this string for rendering in the form
    @address_string = addresses.join("\n")

    @custom_nmap = attributes[:custom_nmap] || ""
    @portscan_speed = (attributes[:portscan_speed] || 5).to_i
    @ports_extra = attributes[:ports_extra].to_s || ""
    @ports_blacklist = attributes[:ports_blacklist].to_s || ""
    @ports_custom = attributes[:ports_custom].to_s || ""
    @portscan_timeout = (attributes[:portscan_timeout] || 300).to_i
    @portscan_source_port = attributes[:portscan_source_port] || ""

    @udp_probes        = set_default_boolean(attributes[:udp_probes], true)
    @finger_users      = set_default_boolean(attributes[:finger_users], true)
    @snmp_scan         = set_default_boolean(attributes[:snmp_scan], false)
    @h323_scan         = set_default_boolean(attributes[:h323_scan], true)
    @identify_services = set_default_boolean(attributes[:identify_services], true)
    @dry_run           = set_default_boolean(attributes[:dry_run], false)
    @single_scan       = set_default_boolean(attributes[:single_scan], false)
    @fast_detect       = set_default_boolean(attributes[:fast_detect], false)
    @initial_nmap      = set_default_boolean(attributes[:initial_nmap], true)
    @initial_webscan   = set_default_boolean(attributes[:initial_webscan], false)
    @smb_username      = attributes[:smb_username] || ""
    @smb_password      = attributes[:smb_password] || ""
    @smb_domain        = attributes[:smb_domain] || ""
    @skip_host_validity_check   = set_default_boolean(attributes[:skip_host_validity_check], false)
    @autotag_os       = set_default_boolean(attributes[:autotag_os], false)

    @blacklist = []
    if attributes[:blacklist_string]
      @blacklist = tags_and_addresses(attributes[:blacklist_string].split(/\s+/))
    end

    @webscan_max_pages   = (attributes[:webscan_max_pages] || 500).to_i
    @webscan_max_minutes = (attributes[:webscan_max_minutes] || 5).to_i
    @webscan_max_threads = (attributes[:webscan_max_threads] || 4).to_i

    @http_username = attributes[:http_username] || ''
    @http_password = attributes[:http_password] || ''
    @http_domain   = attributes[:http_domain]   || ''
    @cookie = attributes[:cookie] || ''
    @user_agent = attributes[:user_agent] || "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)"
    @skipped_hosts = attributes[:skipped_hosts] || []
  end

  def blacklist_string
    blacklist.join("\n")
  end

  def config_to_hash
    {
      'DS_RHOSTS'               => addresses.join(" "),
      'DS_BLACKLIST_HOSTS'      => blacklist.join(" "),
      'workspace'               => workspace.name,
      'username'                => username,
      'DS_CustomNmap'           => custom_nmap,
      'DS_PORTSCAN_SPEED'       => portscan_speed,
      'DS_PORTS_EXTRA'          => ports_extra,
      'DS_PORTS_BLACKLIST'      => ports_blacklist,
      'DS_PORTS_CUSTOM'         => ports_custom,
      'DS_PORTSCAN_TIMEOUT'     => portscan_timeout,
      'DS_PORTSCAN_SOURCE_PORT' => portscan_source_port.to_i,
      'DS_UDP_PROBES'           => udp_probes,
      'DS_FINGER_USERS'         => finger_users,
      'DS_SNMP_SCAN'            => snmp_scan,
      'DS_H323_SCAN'            => h323_scan,
      'DS_IDENTIFY_SERVICES'    => identify_services,
      'DS_SMBUser'              => smb_username.to_s,
      'DS_SMBPass'              => smb_password.to_s,
      'DS_SMBDomain'            => smb_domain.to_s,
      'DS_DRY_RUN'              => dry_run,
      'DS_SINGLE_SCAN'          => single_scan,
      'DS_FAST_DETECT'          => fast_detect,
      'DS_INITIAL_NMAP'         => initial_nmap,
      'DS_INITIAL_WEBSCAN'      => initial_webscan,
      'DS_WEBSCAN_MAX_PAGES'    => webscan_max_pages,
      'DS_WEBSCAN_MAX_MINUTES'  => webscan_max_minutes,
      'DS_WEBSCAN_MAX_THREADS'  => webscan_max_threads,
      'DS_HTTPCookie'           => cookie,
      'DS_USERNAME'             => http_username,
      'DS_PASSWORD'             => http_password,
      'DS_DOMAIN'               => http_domain,
      'DS_UserAgent'            => user_agent,
      'DS_SKIPPED_HOSTS'        => skipped_hosts
    }
  end

  def rpc_call
    conf = config_to_hash
    conf['DS_AUTOTAG_OS'] = autotag_os
    conf['DS_AUTOTAG_TAGS'] = autotag_tags
    client.start_discover(conf)
  end

  def valid?
    unless @skip_host_validity_check
      if addresses.nil? or addresses.empty?
        @error = "At least one IP address is required"
        return false
      end

      #Validate addresses
      hosts = self.validate_hosts
      @addresses = hosts[:valid]
      @skipped_hosts += hosts[:invalid]

      unless @workspace.allow_actions_on?(addresses.join(" "))
        @error = "Target Addresses must be inside workspace boundaries"
        return false
      end
    end

    blacklist.each do |ip|
      next if valid_ip_or_range?(ip)
      @error = "Invalid excluded IP address: #{ip}"
      return false
    end

    unless valid_port_list?(ports_extra)
      @error = "Invalid Extra Ports"
      return false
    end

    unless valid_port_list?(ports_blacklist)
      @error = "Invalid Blacklist Ports"
      return false
    end

    unless valid_port_list?(ports_custom)
      @error = "Invalid Custom Ports"
      return false
    end

    unless (portscan_source_port.strip == "" or (portscan_source_port.strip =~ /^\d+$/ and (portscan_source_port.to_i >= 1 and portscan_source_port.to_i <= 65535)))
      @error = "Invalid Custom Source Port"
      return false
    end

    if portscan_timeout < 0
      @error = "Portscan Timeout must be >= 0"
      return false
    end

    return false unless PORTSCAN_SPEEDS.include?(portscan_speed)

    # Deal with buttoning down custom nmap command lines here.
    if custom_nmap
      if !(custom_nmap.scan(/'/).size % 2).zero?
        @error = "Unbalanced quotes in nmap arguments"
        return false
      end

      if !(custom_nmap.scan(/"/).size % 2).zero?
        @error = "Unbalanced quotes in nmap arguments"
        return false
      end

      # Sub out -A for -O -sV --traceroute
      custom_nmap.gsub!(/-A/,"-O -sV --traceroute")
      if custom_nmap[/([\x00-\x19\x21\x23-\x26\x28\x29\x3b\x2c\x3e\x60\x7b\x7c\x7d\x7e-\xff])/n]
        @error = "Disallowed character '#{$1}' in nmap arguments"
        return false
      end

      nmap_filter_regex = /^-(([iop])|(sC)|(-excludefile|-resume|-script|-datadir|-stylesheet))/

      opts = custom_nmap.split(/[\s]+/).grep(nmap_filter_regex)
      if !opts.empty?
        opt = opts.first
        @error = "Disallowed nmap option: #{opt}."
        case opt
        when "i"
          @error << " Please use Target Addresses option."
        when "o"
          @error
        when "p"
          @error << " Please use the Custom TCP Port Range option."
        end
        return false
      end
    end

    @error = nil
    return true
  end

  def validate_hosts
    valid_hosts = []
    invalid_hosts = []
    addresses.each do |ip|
      if valid_ip_or_range?(ip)
        valid_hosts << ip
      else
        invalid_hosts << ip
      end
    end
    {:valid => valid_hosts, :invalid => invalid_hosts }
  end

  private

  # Technically, it's hard to fail this test, since str.to_i.abs
  # will virtually always return 0 or a real Integer.
  def valid_port_list?(str)
    return true if str.strip.empty?
    ret = true
    ports = str.split(",").map {|x| x.strip.to_i.abs}
    ports.each do |i|
      if i.kind_of?(Integer)
        next
      else
        ret = false
        break
      end
    end
    return ret
  end

  def allows_replay?
    true
  end
end

