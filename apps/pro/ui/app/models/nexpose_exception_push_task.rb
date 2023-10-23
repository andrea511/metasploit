class NexposeExceptionPushTask < TaskConfig
	attr_accessor :console_id
	attr_accessor :nexpose_console, :consoles
	attr_accessor :no_valid_vulns
	attr_accessor :vuln_map
	attr_accessor :vuln_ids
	attr_accessor :approve
	attr_accessor :expiration_set
	attr_accessor :expiration_date
	attr_accessor :exception_map

	require 'yaml'

	REASONS = [
		"Other",
		"False Positive",
		"Compensating Control",
		"Acceptable Use",
		"Acceptable Risk"
	]


	def initialize(attrs)
		super(attrs)
		@vuln_map = {}
		@exception_map = []

		# Look to see if a specific set of vulnerabilties are to be excluded
		if attrs[:vuln_ids] and attrs[:vuln_ids].kind_of?(Array) and attrs[:vuln_ids].length > 0

			qry = ::Mdm::Host.select(
				"hosts.*, vulns.id as vuln_id, vuln_details.title as nx_vuln_title, " +
				"vuln_details.nx_vuln_id as nx_vuln_id, vuln_details.nx_device_id as nx_device_id,  " +
				"vuln_details.id as vuln_details_id"
			).joins(
				' INNER JOIN vulns ON vulns.host_id = hosts.id ' +
				' INNER JOIN vuln_details ON vulns.id = vuln_details.vuln_id ').
			where(
				'hosts.workspace_id = ? and vulns.id in (?) AND vuln_details.src = ?',
				@workspace_id, attrs[:vuln_ids], 'nexpose'
			).order(
				"vuln_details_id ASC"
			)

			qry.all.each do |host|
				@vuln_map[ host.vuln_id.to_i ] = {
					:address   => host.address,
					:vuln_id   => host.vuln_id,
					:nx_device_id  => host.nx_device_id,
					:nx_vuln_id    => host.nx_vuln_id,
					:nx_vuln_title => host.nx_vuln_title,
					:test_result   => "Untested"
				}
			end

			::Mdm::VulnAttempt.where('vuln_id in (?)', @vuln_map.keys).order('id ASC').each do |att|
				next unless @vuln_map[att.vuln_id]
				@vuln_map[att.vuln_id][:test_result] = att.exploited ? "Exploited" : "Not Exploited"
				@vuln_map[att.vuln_id][:test_date]   = att.attempted_at
				@vuln_map[att.vuln_id][:test_reason] = att.fail_reason
				@vuln_map[att.vuln_id][:test_detail] = att.fail_detail
			end

		# Otherwise identify all *tested* vulnerabilities
		else
			qry = ::Mdm::Host.select(
				"hosts.*, vulns.id as vuln_id, vuln_details.title as nx_vuln_title, " +
				"vuln_details.nx_vuln_id as nx_vuln_id, vuln_details.nx_device_id as nx_device_id,  " +
				"vuln_details.id as vuln_details_id, vuln_attempts.attempted_at as vuln_attempted_at, " +
				"vuln_attempts.fail_reason as vuln_fail_reason, vuln_attempts.fail_detail as vuln_fail_detail, " +
				"vuln_attempts.id as vuln_attempt_id, vuln_attempts.exploited as vuln_exploited "
			).joins(
				' INNER JOIN vulns ON vulns.host_id = hosts.id ' +
				' INNER JOIN vuln_details ON vulns.id = vuln_details.vuln_id ' +
				' INNER JOIN vuln_attempts ON vulns.id = vuln_attempts.vuln_id '
			).where(
				'hosts.workspace_id = ? AND vuln_details.src = ?',
				@workspace_id, 'nexpose'
			).order(
				"vuln_attempt_id ASC"
			)

			qry.all.each do |host|
				@vuln_map[ host.vuln_id.to_i ] = {
					:address   => host.address,
					:vuln_id   => host.vuln_id,
					:nx_device_id  => host.nx_device_id,
					:nx_vuln_id    => host.nx_vuln_id,
					:nx_vuln_title => host.nx_vuln_title,
					:test_result   => host.vuln_exploited ? "Exploited" : "Not Exploited",
					:test_date     => host.vuln_attempted_at,
					:test_reason   => host.vuln_fail_reason,
					:test_detail   => host.vuln_fail_detail,
				}
			end
		end

		@consoles = ::Mdm::NexposeConsole.where('enabled = ?', true).all.map{|x| x.name }

		console = attrs[:nexpose_console]
		if console and ( @console = Mdm::NexposeConsole.find_by_name(console) )
			@console_id = @console.id.to_s
		else
			@console = ::Mdm::NexposeConsole.where('enabled = ?', true).first
			if @console
				@console_id = @console.id.to_s
			end
		end

		if attrs[:exceptions]
			attrs[:exceptions].each_pair do |vuln_id, info|
				@exception_map << [
					info['nx_vuln_id'], info['nx_device_id'].to_s, info['reason'].to_s, info['comment']
				]
			end
		end

		@approve = set_default_boolean(attrs[:approve], true)

		@expiration_set = set_default_boolean(attrs[:expiration_set], false)
		if @expiration_set
			# The YYYY-MM-DD format is required
			@expiration_date = DateTime.parse(attrs[:expiration_date].to_s).to_time.strftime("%Y-%m-%d") rescue attrs[:expiration_date].to_s
		end

		if @vuln_map.keys.empty? and @exception_map.empty?
			@no_valid_vulns = true
		end
	end

	def valid?

		# Checks for a valid console id
		if @console_id.to_s.strip.length == 0
			@error = "A valid Nexpose Console is required"
			return false
		end

		# Checks for one or more hosts
		if @vuln_map.length == 0 and @exception_map.length == 0
			@error = "No vulnerabilities with associated Nexpose device IDs were selected"
			return false
		end

		# If you've gotten this far, you're valid.
		@error = nil
		return true
	end

	def config_to_hash
		{
			'workspace'      => workspace.name,
			'username'       => username,
			'DS_NEXPOSE_CID' => console_id,
			'DS_APPROVE'     => approve,
			'DS_EXPIRATION'  => expiration_date,
			'DS_EXCEPTIONS'  => exception_map.to_yaml
		}
	end

	def rpc_call
		client.start_nexpose_exception_push(config_to_hash)
	end

	def allows_replay?
		false
	end
end

