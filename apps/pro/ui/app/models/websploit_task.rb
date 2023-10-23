class WebsploitTask < TaskConfig

  CONNECTIONS = ['auto', 'reverse', 'bind'].map{|x| x.capitalize }
  PAYLOAD_TYPES = ['meterpreter', 'meterpreter 64-bit', 'command shell'].map{|x| x.capitalize }

  attr_accessor :whitelist, :timeout, :limit_sessions
  attr_accessor :connection, :payload_type, :payload_ports, :payload_lhost

  attr_accessor :vulns, :targets, :vids
  attr_accessor :http_username, :http_password, :http_domain, :cookie, :extra_headers, :user_agent

  def initialize(attributes)
    super(attributes)

    @vids = []

    @whitelist = attributes[:whitelist] || []

    @timeout = attributes[:timeout] || 2

    @connection = attributes[:connection] || 'Auto'
    @payload_type = attributes[:payload_type] || 'Meterpreter'
    @payload_ports = attributes[:payload_ports] || '1024-65535'
    @payload_lhost = attributes[:payload_lhost]
    @payload_lhost = nil if @payload_lhost.to_s.strip.empty?

    @limit_sessions = set_default_boolean(attributes[:limit_sessions], true)
    @targets = attributes[:targets] || {}

    @whitelist = tags_and_addresses(@whitelist)

    if attributes[:whitelist_string]
      @whitelist = tags_and_addresses(attributes[:whitelist_string].split(/\s+/))
    end

    if attributes[:blacklist_string]
      @blacklist = tags_and_addresses(attributes[:blacklist_string].split(/\s+/))
    end

    @skip_vuln_check = attributes[:skip_vuln_check]
    @http_username = attributes[:http_username]
    @http_password = attributes[:http_password]
    @http_domain   = attributes[:http_domain]  || 'WORKSTATION'
    @cookie = attributes[:cookie]
    @user_agent = attributes[:user_agent] || 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)'
    @extra_headers = attributes[:extra_headers] || []
    @extra_headers = @extra_headers.select{|x| x.strip.length > 0}

    if @workspace.present? and @workspace.persisted?
      whitelist_hosts = @workspace.hosts.select { |host|
        @whitelist.include?(host.address)
      }

      @vulns = whitelist_hosts.inject([]) { |web_vulns, host|
        web_vulns + host.web_vulns
      }

      @vulns.sort_by { |web_vuln|
        [
            web_vuln.risk,
            web_vuln.category_label,
            web_vuln.web_site.service.host.address
        ]
      }
    end

    @targets.keys.each do |k|
      next if not @targets[k]['enabled']
      @vids << k
    end
  end

  def whitelist_string
    whitelist.join("\n")
  end

  def valid?

    # Validate Timeout
    if timeout.to_f < 0.1 # Allow a six second timeout.
      @error = 'Invalid Timeout: #{timeout}'
      return false
    end

    # Validate Connection
    if !CONNECTIONS.include? connection
      @error = 'Invalid Connection Type: #{connection}'
      return false
    end

    # Validate payload type
    if !PAYLOAD_TYPES.include? payload_type
      @error = 'Invalid payload type: #{payload_type}'
      return false
    end

    # Validate payload connection
    if !CONNECTIONS.include? connection
      @error = 'Invalid Connection Type: #{connection}'
      return false
    end

    # Validate payload listener ports
    r = Rex::Socket.portspec_crack(payload_ports) rescue []
    if r.length == 0
      @error = 'Invalid Payload Ports: #{payload_ports}'
      return false
    end

    # Validate payload listener host override
    if payload_lhost and not valid_ip_or_range?(payload_lhost)
      @error = 'Invalid Payload Mdm::Listener Address: #{payload_lhost}'
      return false
    end

    if @vids.length == 0 and not @skip_vuln_check
      @error = 'No vulnerabilities selected'
      return false
    end

    # If you've gotten this far, you're valid.
    @error = nil
    return true
  end

  def config_to_hash
    conf = {
        'DS_VULNERABILITIES' => vids.join(' '),
        'DS_EXPLOIT_TIMEOUT' => timeout.to_i,
        'workspace'          => workspace.name,
        'username'           => username,
        'DS_LimitSessions'   => limit_sessions,
        'DS_PAYLOAD_METHOD' => connection.downcase,
        'DS_PAYLOAD_TYPE'   => payload_type.downcase,
        'DS_PAYLOAD_PORTS'  => payload_ports
    }

    if @http_username.to_s.strip.length > 0
      conf['DS_HttpUsername'] = @http_username
      conf['DS_HttpPassword'] = @http_password
      conf['DS_DOMAIN']   = @http_domain
    end

    if @cookie.to_s.strip.length > 0
      conf['DS_HTTPCookie'] = @cookie
    end

    if @extra_headers
      conf['DS_HTTPAdditionalHeaders'] = @extra_headers.join('\x01')
    end

    if @user_agent.to_s.strip.length > 0
      conf['DS_UserAgent'] = @user_agent
    end

    if current_profile.settings['payload_prefer_https']
      conf['DS_EnableReverseHTTPS'] = true
    end

    if current_profile.settings['payload_prefer_http']
      conf['DS_EnableReverseHTTP'] = true
    end

    conf['DS_PAYLOAD_LHOST'] = payload_lhost if payload_lhost
    conf
  end

  def rpc_call
    conf = config_to_hash
    client.start_websploit(conf)
  end

  def allows_replay?
    true
  end
end

