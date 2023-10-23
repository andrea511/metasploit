class CleanupTask < TaskConfig
	attr_accessor :cleanup_sessions


	def initialize(attrs)
		super(attrs)
		@cleanup_sessions    = attrs[:cleanup_sessions] || []
    @run_on_all_sessions = set_default_boolean(attrs[:run_on_all_sessions], false)
	end

	def valid?
		# Checks for a session selected.
		if cleanup_sessions.nil? or cleanup_sessions.empty?
			@error = "At least one session is required"
			return false
		end

		# If you've gotten this far, you're valid.
		@error = nil
		return true
	end

	def config_to_hash
		session_list = ''
		unless @run_on_all_sessions
			session_list = cleanup_sessions.map { |x| Mdm::Session.find(x).local_id.to_s }.join(" ")
		end

		{
			'workspace'   => workspace.name,
			'username'    => username,
			'DS_SESSIONS' => session_list,
			'DS_DBSESSIONS' => cleanup_sessions.join(" ")
		}
	end

	def rpc_call
		client.start_cleanup(config_to_hash)
	end

	def allows_replay?
		true
	end
end

