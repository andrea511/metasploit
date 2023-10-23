class WebauditTask < TaskConfig

	attr_accessor :whitelist, :urls, :max_requests, :max_minutes, :max_threads, :max_instances, :known_servers, :known_targets
	attr_accessor :http_username, :http_password, :http_domain, :cookie, :extra_headers, :user_agent
	attr_accessor :session_cookie_name, :direct_object_reference

	def initialize(attributes)
		super(attributes)

		@session_cookie_name = attributes[:session_cookie_name]
		@direct_object_reference = attributes[:direct_object_reference] == '1'

		@whitelist = attributes[:whitelist] || []
		@whitelist = tags_and_addresses(@whitelist)

		@max_requests   = (attributes[:max_requests] || 500).to_i
		@max_minutes = (attributes[:max_minutes] || 5).to_i
		@max_threads = (attributes[:max_threads] || 4).to_i
		@max_instances = (attributes[:max_instances] || 3).to_i
		@known_targets = attributes[:known_targets] || {}
		@urls = attributes[:urls] || ""

		@known_servers = []

		@skip_urls_check = attributes[:skip_urls_check]
		@http_username = attributes[:http_username]
		@http_password = attributes[:http_password]
		@http_domain = attributes[:http_domain] || 'WORKSTATION'
		@cookie = attributes[:cookie]
		@user_agent = attributes[:user_agent] || "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)"
		@extra_headers = attributes[:extra_headers] || []
		@extra_headers = @extra_headers.select{|x| x.strip.length > 0}

		# Only load these when the form is first requested, not on submission
		if @workspace.present? and @workspace.persisted? and @known_targets.keys.length == 0
			@workspace.web_unique_forms(@whitelist).each do |form|
				url = form.web_site.to_url(true) + form.path
				@known_servers << [form.web_site.vhost, url, form.web_site.service.host.address]
			end
			@known_servers.sort!{|a,b| a[1] <=> b[1] }
			@known_servers.uniq!
		end

		@known_targets.keys.each do |k|
			next if not @known_targets[k]['enabled']
			vhost = @known_targets[k]['vhost'].to_s
			url   = @known_targets[k]['url'].to_s

			if not vhost.strip.empty?
				url = vhost + "," + url
				@urls << "\n" + url
			end
		end

		@urls = @urls.split(/\s+/).sort.uniq.join("\n")
	end

	def valid?

		if @max_minutes < 1.0
			@error = "Minimum form time limit is 1 minute"
			return false
		end

		if @max_requests < 1.0
			@error = "Minimum form request limit is 1"
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

		if @max_instances < 1.0
			@error = "Minimum form instance count is 1"
			return false
		end

		if @urls.strip.empty? and not @skip_urls_check
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
			'DS_MAX_MINUTES'     => max_minutes,
			'DS_MAX_THREADS'     => max_threads,
		}

		if @session_cookie_name
			conf['DS_SESSION_FIXATION_SESSION_COOKIE_NAME'] = @session_cookie_name
		end

		if @direct_object_reference
			conf['DS_DIRECT_OBJECT_REFERENCE_ENABLE'] = true
		end

		if @http_username.to_s.strip.length > 0
			conf['DS_HttpUsername'] = @http_username
			conf['DS_HttpPassword'] = @http_password
			conf['DS_DOMAIN'] = @http_domain
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
		client.start_webaudit(conf)
	end

	def allows_replay?
		true
	end
end

