class Metasploit::Pro::LportMapper

  attr_accessor :reserved_lports, :allowed_ports
  attr_accessor :use_rpc

  def initialize
    @reserved_lports =  []
    @allowed_ports = Rex::Socket.portspec_crack("1024-65535")
    @use_rpc = true
  end

  def find_usable_lport(ipv6=false)
    1.upto(allowed_ports.length + 100) do
      lport = configure_payload_listener
      next if reserved_lports.include? lport
      return lport if lport_available?(lport,ipv6)
    end
    return nil
  end

  def lport_available?(lport, ipv6=false)
    if use_rpc
      client = Pro::Client.get
      client.lport_available?(lport,ipv6)
    else
      begin
        # Force the local Comm to prevent issues with session routes. Note
        # that this will cause all routed exploits to still route their
        # payloads through the normal network. The pivoted target must
        # have network access back to the attack for this to work. Bind
        # shells can be used to avoid this scenario.

        lserv = Rex::Socket.create_tcp_server(
            'LocalHost' => (ipv6 ? Metasploit::Pro::Engine::Rpc::Lport::IPV6_LOCALHOST_IP : Metasploit::Pro::Engine::Rpc::Lport::IPV4_LOCALHOST_IP),
            'LocalPort' => lport,
            'Comm'      => ::Rex::Socket::Comm::Local
        )
        # Grab the chosen port
        lport = lserv.getsockname[2]

        # Shut down the original socket
        lserv.close
        # Break the loop indicating we found a port
        return true
      rescue ::Exception => e
        return false
        # print_error("find_usable_lport: #{e.class} #{e} #{e.backtrace}")
      end
    end
  end

  def configure_payload_listener
    ports = allowed_ports.dup

    @mutex ||= ::Mutex.new

    ret = nil

    @mutex.synchronize do
      @listener_idx  ||= -1
      ret = ports[ ( @listener_idx += 1 ) % ports.length ]
    end

    ret
  end

  def allowed_ports=(ports)
    if ports.class == String
      raise ArgumentError, "Invalid Port Range Assignment: #{ports}" unless ports =~ /^(\d)+\-(\d)+$/
      ports = Rex::Socket.portspec_crack(ports) 
    end
    if ports_valid?(ports, false)
      @allowed_ports = ports
    else
      raise ArgumentError, "Invalid Port Range Assignment: #{ports}"
    end
  end

  def reserved_lports=(ports)
    if ports.class == String
      raise ArgumentError, "Invalid Port Range Assignment: #{ports}" unless ports =~ /^(\d)+\-(\d)+$/
      ports = Rex::Socket.portspec_crack(ports) 
    end
    if ports_valid?(ports, true)
      @reserved_lports = ports
    else
      raise ArgumentError, "Invalid Port Range Assignment: #{ports}"
    end
  end



  def ports_valid?(aports, can_be_empty = true)
    return false if aports.nil?
    return false unless aports.class == Array 
    unless can_be_empty
      return false if aports.empty?
    end
    aports.each do |ap| 
      return false unless ap.class == Integer
      return false if ap > 65535
      return false if ap < 1
    end
    return true
  end

end
