class NexposeAssetGroupPushTask < TaskConfig
	attr_accessor :group_name
	attr_accessor :group_desc
	attr_accessor :whitelist
	attr_accessor :whitelist_string
	attr_accessor :console_id
	attr_accessor :tag_ids
	attr_accessor :nexpose_console, :consoles
	attr_accessor :no_valid_hosts

	def initialize(attrs)
		super(attrs)
		@group_name  = attrs[:group_name]
		@group_desc  = attrs[:group_desc]


		@whitelist = tags_and_addresses(@whitelist)
		if attrs[:whitelist_string]
			@whitelist = tags_and_addresses(attrs[:whitelist_string].split(/\s+/))
			@whitelist = @whitelist.map{|x| x unless x.empty?}.compact
		end

		if attrs[:tag_ids]
			ftag = Mdm::Tag.find(attrs[:tag_ids].uniq).first
			@whitelist = tags_and_addresses( Mdm::Tag.find(attrs[:tag_ids].uniq ).map{|x| "#" + x.name}.uniq )
			@group_name ||= ftag.name
			@group_desc ||= ( ftag.desc || "Created by Metasploit Pro tag ##{ftag.name}" )
		end

		@consoles = ::Mdm::NexposeConsole.where('enabled = ?', true).all.map{|x| x.name }

		console = attrs[:nexpose_console]
		if console and ( @console = Mdm::NexposeConsole.find_by_name(console) )
			@console_id = @console.id.to_s	
		end

		@device_ids = ::Mdm::Host.select("hosts.*,host_details.*").
			joins('INNER JOIN host_details ON hosts.id = host_details.host_id').
			where('workspace_id = ? and hosts.address in (?)', @workspace_id, @whitelist).
			map{|x| [x.address, x.nx_device_id] }.uniq.select{|x| x[1] }

		@whitelist = @device_ids.map{|x| x[0] }
		@whitelist_string = @whitelist.join("\n")

		if @whitelist.empty?
			@no_valid_hosts = true
		end
	end

	def valid?

		# Checks for a valid group name
		if @group_name.to_s.strip.length == 0
			@error = "An asset group name is required"
			return false
		end

		# Checks for a valid group description
		if @group_desc.to_s.strip.length == 0
			@error = "An asset group description required"
			return false
		end

		# Checks for a valid console id
		if @console_id.to_s.strip.length == 0
			@error = "A valid Nexpose Console is required"
			return false
		end

		# Checks for one or more hosts
		if @whitelist.length == 0
			@error = "No hosts were specified that have a Nexpose device-id"
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
			'DS_GROUP_NAME'  => group_name,
			'DS_GROUP_DESC'  => group_desc,
			'DS_NEXPOSE_CID' => console_id,
			'DS_WHITELIST_HOSTS'  => @whitelist.join(" ")
		}
	end

	def rpc_call
		client.start_nexpose_asset_group_push(config_to_hash)
	end

	def allows_replay?
		false
	end
end

