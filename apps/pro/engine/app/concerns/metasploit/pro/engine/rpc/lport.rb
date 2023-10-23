module Metasploit::Pro::Engine::Rpc::Lport

  IPV4_LOCALHOST_IP = '0.0.0.0'
  IPV6_LOCALHOST_IP = '::'

  def rpc_lport_available?(lport, ipv6=false)
    begin
    # Force the local Comm to prevent issues with session routes. Note
    # that this will cause all routed exploits to still route their
    # payloads through the normal network. The pivoted target must
    # have network access back to the attack for this to work. Bind
    # shells can be used to avoid this scenario.
    
      lserv = Rex::Socket.create_tcp_server(
        'LocalHost' => (ipv6 ? IPV6_LOCALHOST_IP : IPV4_LOCALHOST_IP),
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
