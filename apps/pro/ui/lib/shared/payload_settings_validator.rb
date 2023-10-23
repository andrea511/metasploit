class Shared::PayloadSettingsValidator
  include ActiveModel::Validations
  include Metasploit::Pro::IpRangeValidation

  CONNECTIONS = ["auto", "reverse", "bind"].map{|x| x.capitalize }
  PAYLOAD_TYPES = ["meterpreter", "meterpreter 64-bit", "command shell", "powershell"].map{|x| x.capitalize }

  # @attr_reader <String> payload type
  attr_reader :payload_type
  # @attr_reader <String> connection type
  attr_reader :connection_type
  # @attr_reader <String> listener ports
  attr_reader :listener_ports
  # @attr_reader <String> listener host
  attr_reader :listener_host

  validate  :payload_type_valid
  validate  :payload_connection_valid
  validate  :listener_ports_valid
  validate  :listener_host_valid

  def initialize(args={})
    @payload_type = args[:payload_type]
    @connection_type = args[:connection_type]
    @listener_ports = args[:listener_ports]
    @listener_host = args[:listener_host]

    # We're using a older version of ActiveModel :-/ so we still need this
    # Pull args into attr_accessors
    # This has calls that assume whitelist_hosts exist, so
    # it needs to be after the {white,black}_list ivars
    args.each do |attr, value|
      method = "#{attr}="
      if self.respond_to?(method)
        self.public_send(method, value)
      end
    end if args
  end

  # Validate payload type
  def payload_type_valid
    if !PAYLOAD_TYPES.include? @payload_type
      errors.add :payload_type, "Invalid payload type: #{@payload_type}"
    end
  end

  # Validate payload connection
  def payload_connection_valid
    if !CONNECTIONS.include? @connection_type
      errors.add :connection_type, "Invalid Connection Type: #{@connection_type}"
    end
  end

  # Validate payload listener ports
  def listener_ports_valid
    r = Rex::Socket.portspec_crack(@listener_ports) rescue []
    if r.length == 0
      errors.add :listener_ports, "Invalid Payload Ports: #{@listener_ports}"
    end
  end

  # Validate payload listener host override
  def listener_host_valid
    if !@listener_host.empty? and not valid_ip_or_range?(@listener_host)
      errors.add :listener_host, "Invalid Payload Address: #{@listener_host}"
    end
  end

end

