class CollectEvidenceTask < TaskConfig

	attr_accessor :collect_sessions
	attr_accessor :collect_sysinfo
	attr_accessor :collect_passwd
	attr_accessor :collect_screenshots
	attr_accessor :collect_ssh
	attr_accessor :collect_files
	attr_accessor :collect_files_pattern
	attr_accessor :collect_files_count
	attr_accessor :collect_files_size # kilobytes
  attr_accessor :collect_apps
  attr_accessor :collect_svcs
  attr_accessor :collect_drives
  attr_accessor :collect_users
  attr_accessor :collect_domain
	attr_accessor :crack_passwords


	def initialize(attrs)
		super(attrs)

		@collect_sessions      = attrs[:collect_sessions] || []
    @collect_apps          = set_default_boolean(attrs[:collect_apps], true)
    @collect_drives        = set_default_boolean(attrs[:collect_drives], true)
    @collect_users         = set_default_boolean(attrs[:collect_users], true)
    @collect_domain        = set_default_boolean(attrs[:collect_domain], true)
		@collect_sysinfo       = set_default_boolean(attrs[:collect_sysinfo], true)
		@collect_passwd        = set_default_boolean(attrs[:collect_passwd], true)
		@collect_screenshots   = set_default_boolean(attrs[:collect_screenshots], true)
		@collect_ssh           = set_default_boolean(attrs[:collect_ssh], true)
		@collect_files         = set_default_boolean(attrs[:collect_files], false)
		@run_on_all_sessions   = set_default_boolean(attrs[:run_on_all_sessions], false)
		@crack_passwords       = set_default_boolean(attrs[:crack_passwords], false)
		@collect_files_pattern = attrs[:collect_files_pattern] || 'boot.ini'
		@collect_files_count   = attrs[:collect_files_count] || 10
		@collect_files_size    = attrs[:collect_files_size] || 100

		@collectables = [collect_sysinfo,
      collect_passwd,
      collect_screenshots,
      collect_ssh,
      collect_files,
      collect_apps,
      collect_drives,
      collect_users,
      collect_domain
    ]
	end


	def valid?
		# Checks for a session selected.
		if not @run_on_all_sessions and (collect_sessions.nil? or collect_sessions.empty?)
			@error = "At least one session is required"
			return false
		end

		# Checks for a collectable item
		unless @collectables.include? true 
			@error = "At least one collectable item is required"
			return false
		end

		# Checks that file parameters are sensical
		if collect_files
			if collect_files_pattern.nil? or collect_files_pattern.empty?
				@error = "A file pattern must be provided."
				return false
			end
			if collect_files_count.to_i < 1
				@error = "Invalid file count: #{collect_files_count}"
				return false
			end
			if collect_files_size.to_f < 0.1
				@error = "Invalid file size: #{collect_files_size}"
				return false
			end
		end

		# If you've gotten this far, you're valid.
		@error = nil
		return true
	end

	def config_to_hash
                session_list = ''
                unless @run_on_all_sessions
                        session_list = collect_sessions.map { |x| Mdm::Session.find(x).local_id.to_s }.join(" ")
                end

		{
			'workspace'                => workspace.name,
			'username'                 => username,
			'DS_SESSIONS'              => session_list,
      'DS_COLLECT_APPS'          => collect_apps,
      'DS_COLLECT_DRIVES'        => collect_drives,
      'DS_COLLECT_USERS'         => collect_users,
      'DS_COLLECT_DOMAIN'        => collect_domain,
			'DS_COLLECT_SYSINFO'       => collect_sysinfo,
			'DS_COLLECT_PASSWD'        => collect_passwd,
			'DS_COLLECT_SCREENSHOTS'   => collect_screenshots,
			'DS_COLLECT_SSH'           => collect_ssh,
			'DS_COLLECT_FILES'         => collect_files,
			'DS_COLLECT_FILES_PATTERN' => collect_files_pattern,
			'DS_COLLECT_FILES_COUNT'   => collect_files_count,
			'DS_COLLECT_FILES_SIZE'    => collect_files_size,
			'DS_CRACK_PASSWORDS'        => crack_passwords
		}
	end

	def rpc_call
		client.start_collect(config_to_hash)
	end

	def allows_replay?
		true
	end
end

