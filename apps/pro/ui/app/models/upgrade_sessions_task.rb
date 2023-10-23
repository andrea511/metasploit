class UpgradeSessionsTask < TaskConfig
	attr_accessor :upgrade_sessions


	def initialize(attrs)
		super(attrs)
		@upgrade_sessions    = attrs[:upgrade_sessions] || []
                @run_on_all_sessions = set_default_boolean(attrs[:run_on_all_sessions], false)
	end

	def valid?
		# Checks for a session selected.
		if upgrade_sessions.nil? or upgrade_sessions.empty?
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
			session_list = upgrade_sessions.map { |x| Mdm::Session.find(x).local_id.to_s }.join(" ")
		end

		{
			'workspace'   => workspace.name,
			'username'    => username,
			'DS_SESSIONS' => session_list,
			'DS_DBSESSIONS' => upgrade_sessions.join(" ")
		}
	end

	def rpc_call
		client.start_upgrade_sessions(config_to_hash)
	end

	def allows_replay?
		false
	end
end

