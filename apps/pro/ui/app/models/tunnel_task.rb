class TunnelTask < TaskConfig

	attr_accessor :tunnel_session
	attr_accessor :tunnel_dhcp
	attr_accessor :tunnel_address
	attr_accessor :tunnel_netmask
	attr_accessor :tunnel_interface
	attr_accessor :tunnel_network
	attr_accessor :interfaces, :all_interfaces, :error
	attr_accessor :missing_drivers

	def initialize(attrs)
		super(attrs)

		@tunnel_session      = attrs[:tunnel_session]
		@tunnel_interface    = attrs[:tunnel_interface] || "0"

		tunnel_setting       = attrs[:tunnel_dhcp] || ""
		@tunnel_dhcp         = set_default_boolean(tunnel_setting, true)

		@tunnel_address      = attrs[:tunnel_address] || ""
		@tunnel_netmask      = attrs[:tunnel_netmask] || ""
		@tunnel_network      = attrs[:tunnel_network] || ""
		@interfaces          = attrs[:interfaces] || {}
		@all_interfaces      = attrs[:all_interfaces] || {}
		@error               = attrs[:error] || nil
		@missing_drivers     = false

		if @error == "VPN Pivot drivers are not installed"
			@missing_drivers = true
		end

		@tunnel_dhcp = false if @tunnel_dhcp.to_s == "false"
	end

	def suggested_address
		return "" if @interfaces.keys.length == 0
		inti = @interfaces.keys.sort{|a,b| a.to_i <=> b.to_i }[0]
		intf = @interfaces[inti]
		intf['address'].sub(/\d+$/, '?')
	end

	def suggested_netmask
		return "" if @interfaces.keys.length == 0
		inti = @interfaces.keys.sort{|a,b| a.to_i <=> b.to_i }[0]
		intf = @interfaces[inti]
		intf['netmask']
	end

	def interface_options
		labels = []
		ids    = []

		@interfaces.keys.sort{|a,b| a.to_i <=> b.to_i }.each do |i|
			intf = @interfaces[i]
			ids    << i
			labels << " ##{i} - #{intf["address"]}/#{intf["netmask"]} - #{intf["description"]} "

		end

		labels.zip(ids)
	end

	def valid?
		# Checks for a session selected.
		if tunnel_session.nil? or tunnel_session.empty?
			@error = "A valid session is required"
			return false
		end

		# Checks for an interface selected.
		if tunnel_interface.nil? or tunnel_interface.empty?
			@error = "A valid interface is required"
			return false
		end

		# Checks for a collectable item
		if ! @tunnel_dhcp and (@tunnel_address.empty? or @tunnel_netmask.to_s.empty?)
			@error = "A valid address and netmask is required"
			return false
		end

		if ! @tunnel_dhcp
			valid_addr = Rex::Socket::RangeWalker.new(@tunnel_address) rescue nil
			valid_mask = Rex::Socket::RangeWalker.new(@tunnel_netmask.to_s) rescue nil
			if not (valid_addr and valid_mask)
				@error = "A valid address and netmask is required"
				return false
			end
		end

		# If you've gotten this far, you're valid.
		@error = nil
		return true
	end

	def rpc_call
		conf = {
			'workspace'                 => workspace.name,
			'username'                  => username,
			'DS_SESSION'                => tunnel_session,
			'DS_INTERFACE'              => tunnel_interface,
			'DS_DHCP'                   => tunnel_dhcp ? true : false,
			'DS_NETWORK'                => tunnel_network.to_s
		}

		if not tunnel_dhcp
			conf['DS_TUNNEL_ADDRESS'] = tunnel_address
			conf['DS_TUNNEL_NETMASK'] = tunnel_netmask.to_s
		end

		client.start_tunnel(conf)
	end

end

