class WebscanTask < TaskConfig

  attr_accessor :whitelist, :urls, :max_pages, :max_minutes, :max_threads, :known_targets, :known_servers
  attr_accessor :http_username, :http_password, :http_domain, :cookie, :extra_headers,
                :user_agent, :targeted, :exclude_path_patterns
  attr_accessor :unauthorized_access_url_patterns, :unauthorized_access_forbidden_phrases
  attr_accessor :ssl_required , :report_weak

  include Metasploit::Pro::AttrAccessor::Boolean

  def initialize(attributes)
    super(attributes)

    @targeted  = attributes[:targeted]
    @whitelist = attributes[:whitelist] || []
    @whitelist = tags_and_addresses(@whitelist)

    @exclude_path_patterns = attributes[:exclude_path_patterns]
    @max_pages   = (attributes[:max_pages] || 500).to_i
    @max_minutes = (attributes[:max_minutes] || 5).to_i
    @max_threads = (attributes[:max_threads] || 4).to_i
    @known_targets = attributes[:known_targets] || {}
    @urls = attributes[:urls] || ""

    @unauthorized_access_url_patterns =
      attributes[:unauthorized_access_url_patterns].to_s

    @unauthorized_access_forbidden_phrases =
      attributes[:unauthorized_access_forbidden_phrases].to_s

    @http_username = attributes[:http_username]
    @http_password = attributes[:http_password]
    @http_domain   = attributes[:http_domain] || 'WORKSTATION'
    @cookie = attributes[:cookie]
    @user_agent = attributes[:user_agent] || "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
    @extra_headers = attributes[:extra_headers] || []
    @extra_headers = @extra_headers.select{|x| x.strip.length > 0}
    @ssl_required = set_default_boolean(attributes[:ssl_required], false)
    @report_weak  = set_default_boolean(attributes[:report_weak], false)
    @known_servers = []

    # Only load these when the form is first requested, not on submission
    if @workspace.present? and @workspace.persisted? and @known_targets.keys.length == 0

      @workspace.web_sites.each do |site|
        next if not @whitelist.include?(site.service.host.address)
        @known_servers << [ site.vhost, site.to_url(true), site.service.host.address, site.service.info ]
      end

      @workspace.services.where("services.state = ? and services.proto = ? and ( services.name = ? or services.name = ? )", "open", "tcp", "http", "https").each do |service|
        next if not @whitelist.include?(service.host.address)

        proto = (service.name == "https") ? "https" : "http"
        ssl   = (service.name == "https") ? true : false
        host  = service.host.address
        port  = service.port

        # Handle IPv6 hosts slightly differently
        if Rex::Socket.is_ipv6?(host)
          host = "[#{host}]"
        end

        vhost = service.host.name.to_s
        next unless valid_vhost(vhost)
        url   = "#{proto}://#{host}"
        if not ((proto == "http" and port == 80) or (proto == "https" and port == 443))
          url += ":#{port}"
        end

        # Skip services where we have an existing site with the same host:port and no VHOST is found
        next if (vhost.to_s.empty? and @known_servers.select{|s| s[1] == url}.length > 0)
        @known_servers << [vhost, url, host, service.info.to_s]
      end

      @known_servers.sort!{|a,b| a[1] <=> b[1] }
      @known_servers.uniq!
    end

    @known_targets.keys.each do |k|
      next if not @known_targets[k]['enabled']
      vhost = @known_targets[k]['vhost']
      url   = @known_targets[k]['url']

      if not vhost.strip.empty?
        url = vhost + "," + url
        @urls << "\n" + url
      else
        @urls << "\n" + url
      end
    end

    @urls = @urls.split(/\s+/).sort.uniq.join("\n")
  end

  def valid?

    if @max_minutes < 1.0
      @error = "Minimum crawl time limit is 1 minute"
      return false
    end

    if @max_pages < 1.0
      @error = "Minimum page limit is 1"
      return false
    end

    if @max_threads < 1.0
      @error = "Minimum thread count is 1"
      return false
    end

    if @max_threads > 10
      @error = "Maximum thread count is 10"
      return false
    end

    if @urls.strip.empty?
      @error = "No valid URLs have been provided"
      return false
    end

    # If you've gotten this far, you're valid.
    @error = nil
    return true
  end

  def config_to_hash
    conf = {
      'workspace'          => workspace.name,
      'username'           => username,
      'DS_URLS'            => urls,
      'DS_MAX_PAGES'       => max_pages,
      'DS_MAX_MINUTES'     => max_minutes,
      'DS_MAX_THREADS'     => max_threads,
      'DS_SSL_REQUIRED'    => ssl_required,
      'DS_REPORT_WEAK'     => report_weak,
      'DS_UNAUTHORIZED_ACCESS_URL_PATTERNS'      => unauthorized_access_url_patterns,
      'DS_UNAUTHORIZED_ACCESS_FORBIDDEN_PHRASES' => unauthorized_access_forbidden_phrases
    }

    if @exclude_path_patterns
      conf['DS_ExcludePathPatterns'] = @exclude_path_patterns
    end

    if @http_username.to_s.strip.length > 0
      conf['DS_HttpUsername'] = @http_username
      conf['DS_HttpPassword'] = @http_password
      conf['DS_DOMAIN']   = @http_domain
    end

    if @cookie.to_s.strip.length > 0
      conf['DS_HTTPCookie'] = @cookie
    end

    if @extra_headers
      conf['DS_HTTPAdditionalHeaders'] = @extra_headers.join("\x01")
    end

    if @user_agent.to_s.strip.length > 0
      conf['DS_UserAgent'] = @user_agent
    end
    conf
  end

  def rpc_call
    conf = config_to_hash
    client.start_webscan(conf)
  end

  def allows_replay?
    true
  end

  private

  # ensure vhost value is a valid label for dns resolution per RFC 1123
  # in the future it may be reasonable to extend this to a valid `hostname` per RFC 952
  def valid_vhost(vhost)
    label = vhost.split('.').first
    label =~ /\A(?!-)[a-zA-Z0-9-]{1,63}(?<!-)\z/
  end
end

