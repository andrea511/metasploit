class ReplayTask < TaskConfig

	CONNECTIONS = ["auto", "reverse", "bind"].map{|x| x.capitalize }
	PAYLOAD_TYPES = ["meterpreter", "meterpreter 64-bit", "command shell", "powershell"].map{|x| x.capitalize }

	attr_accessor :timeout
	attr_accessor :connection, :payload_type, :payload_ports, :payload_lhost

	def initialize(attributes)
		super(attributes)
		@connection = attributes[:connection] || "Auto"
		@payload_type = attributes[:payload_type] || "Meterpreter"
		@payload_ports = attributes[:payload_ports] || "1024-65535"
		@payload_lhost = attributes[:payload_lhost]
		@payload_lhost = nil if @payload_lhost.to_s.strip.empty?
		@timeout = attributes[:timeout] || 5
	end


	def valid?
		# Validate payload type
		if !PAYLOAD_TYPES.include? payload_type
			@error = "Invalid payload type: #{payload_type}"
			return false
		end

		# Validate payload connection
		if !CONNECTIONS.include? connection
			@error = "Invalid Connection Type: #{connection}"
			return false
		end

		# Validate payload listener ports
		r = Rex::Socket.portspec_crack(payload_ports) rescue []
		if r.length == 0
			@error = "Invalid Payload Ports: #{payload_ports}"
			return false
		end

		# Validate payload listener host override
		if payload_lhost and not valid_ip_or_range?(payload_lhost)
			@error = "Invalid Payload Mdm::Listener Address: #{payload_lhost}"
			return false
		end

		# If you've gotten this far, you're valid.
		@error = nil
		return true
	end

	def rpc_call
		conf = {
			'workspace'          => workspace.name,
			'username'           => username,
			'DS_PAYLOAD_METHOD'  => connection.downcase,
			'DS_PAYLOAD_TYPE'    => payload_type.downcase,
			'DS_PAYLOAD_PORTS'   => payload_ports,
			'DS_EXPLOIT_TIMEOUT' => timeout.to_i
		}
		conf['DS_PAYLOAD_LHOST'] = payload_lhost if payload_lhost
		client.start_replay(conf)
	end
end

