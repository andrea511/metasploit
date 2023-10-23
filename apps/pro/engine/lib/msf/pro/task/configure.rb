
module Msf
###
#
# This module provides shared methods for top-level Pro modules
#
###
module Pro
module Task
module Configure

  # Builds a complete list of target hosts given a workspace, a whitelist, and a blacklist.
  # Report expects hosts that are not alive as well, so it is the oddman out
  # TODO: Refactor the gd whitelist functionality as it is bollocks
  def gen_included_hosts()
    ::ApplicationRecord.connection_pool.with_connection {
      if self.refname.include? "pro/report"
        if @whitelist.empty?
          if @blacklist.empty?
            @included_hosts = myworkspace.hosts
          else
            @included_hosts = myworkspace.hosts.where("address not in (?)", @blacklist.keys)
          end
        else
          @included_hosts = myworkspace.hosts.where(:address => @whitelist.keys )
        end
      else
        if @whitelist.empty?
          @included_hosts = myworkspace.hosts.where(:state => 'alive')
        else
          @included_hosts = myworkspace.hosts.where(:state => 'alive', :address => @whitelist.keys )
        end
      end
    }
  end

  def process_whitelist
    whitelist_conf = datastore['WHITELIST_HOSTS']
    blacklist_conf = datastore['BLACKLIST_HOSTS']

    @whitelist = {}
    @blacklist = {}

    if(whitelist_conf and not whitelist_conf.strip.empty?)
      r = Rex::Socket::RangeWalker.new(whitelist_conf)

      if r.num_ips > 65536
        raise RuntimeError, "IP address range is too large (maximum is 65,536 hosts)"
      end

      while(ip = r.next_ip)
        @whitelist[ip] = true
      end
    end

    if(blacklist_conf and not blacklist_conf.strip.empty?)
      r = Rex::Socket::RangeWalker.new(blacklist_conf)

      if r.num_ips > 65536
        raise RuntimeError, "IP address range is too large (maximum is 65,536 hosts)"
      end

      while(ip = r.next_ip)
        @blacklist[ip] = true
        @whitelist.delete(ip)
      end
    end

    if @whitelist['127.0.0.1']
      @whitelist.delete('127.0.0.1')
      print_error("Scanning 127.0.0.1 is not currently supported")
    end

    gen_included_hosts()
  end

  def configure_module(mod, num = nil)
    mod.import_defaults
    mod.register_parent(self)
    mod.datastore['VERBOSE']         = true
    mod.datastore['ShowProgress']    = false
    mod.datastore['TimestampOutput'] = true
    mod.datastore['ExploitNumber']   = num
    mod.datastore['AutoRunScript']   = self.datastore['AutoRunScript'] if self.datastore['AutoRunScript']
    mod[:task]                       = self[:task]
    # Force any TCP listeners to use the local communication channel only
    mod.datastore['ListenerComm'] = 'local'

    configure_module_exe_templates(mod)

    mod.init_ui(self.user_input, self.user_output)
  end

  def configure_module_exe_templates(mod)
    if framework.esnecil_support_ca_signed?
      mod.datastore['EXE::Path'] = pro_exe_template_directory
      mod.datastore['EXE::FallBack'] = true
      mod.datastore['EXE::OldMethod'] = true
    end
  end

  def configure_payload(mod, rhost, opts={})
    return if not mod.respond_to?(:compatible_payloads)

    ::ApplicationRecord.connection_pool.with_connection {
      # Attempt to find a database record for this host
      hinf = myworkspace.hosts.find_by_address(rhost)
      is_windows = hinf && hinf.os_name =~ /windows/i

      # Check if the host is Windows
      if is_windows ||
          hinf.nil? && mod.platform.platforms.any? { |plat| plat == Msf::Module::Platform::Windows }
        mod.datastore['DynamicStager'] = self.datastore['DynamicStager']
      # Check if the module can target Windows if we don't have the host for some reason
      else
        # If the module does not target the Windows platform, disable DynamicStagers
        # as we do not have non-Windows DynamicStagers. There is a final check
        # in the stager generation code, but we can avoid confusing log lines
        # here.
        mod.datastore['DynamicStager'] = false
      end

      if mod.datastore['DynamicStager'] == true
        print_status("Increasing WfsDelay to 5 minutes for Dynamic Stagers")
        mod.datastore['WfsDelay'] = 300
      end

      # Make sure this is in compressed form for IPv6
      rhost = Rex::Socket.compress_address(rhost)

      # Create a toggle for IPv6 payload mode
      ipv6  = Rex::Socket.is_ipv6?(rhost)

      # Find compatible payload modules
      pset = mod.compatible_payloads.map{|x| x[0] }

      # Figure out what connection method to use
      conn = get_payload_method(rhost)

      # Ensure payload_type is set from module data
      datastore['PAYLOAD_TYPE'] = mod.datastore['PAYLOAD_TYPE'] unless datastore['PAYLOAD_TYPE']
      # Handle reverse connect payload choices
      if conn == :reverse

        # Force the listener to always bind to the ANY address
        mod.datastore['ReverseListenerBindAddress'] = '0.0.0.0'

        # Force the listener to use the local communication channel only
        mod.datastore['ReverseListenerComm'] = 'local'

        pref = compatible_payloads('reverse', ipv6)
        enable_https = datastore['EnableReverseHTTPS'] || opts[:enable_reverse_https]
        enable_http = datastore['EnableReverseHTTP'] || opts[:enable_reverse_http]
        if !(enable_http || enable_https)
          pref.reject!{|x| x.index('http')}
        elsif !enable_https
          pref.reject!{|x| x.index('https')}
        end

        # Tune the payload set for exploits using an automatic target
        if mod.datastore['TARGET'] =~ /Automatic/i or
           (mod.respond_to?(:default_target) and
            mod.default_target and
            mod.targets[ mod.default_target ].name =~ /Automatic/i)

          # Move Java to the top of the list when we can't assume a windows target
          if pset.include?('java/meterpreter/reverse_tcp') && is_windows
            pref.delete('java/meterpreter/reverse_tcp')
            pref.unshift('java/meterpreter/reverse_tcp')
          end
        end

        pref.each do |n|
          if(pset.include?(n))
            mod.datastore['PAYLOAD'] = n

            lport = find_usable_lport(ipv6, opts['payload_ports'])
            if not lport
              print_error("Fatal: Could not find a viable listener port")
              return
            end

            mod.datastore['LPORT'] = lport.to_s

            if datastore['PAYLOAD_LHOST'].present?
              lhost = datastore['PAYLOAD_LHOST']
            elsif opts['payload_lhost'].present?
              lhost = opts['payload_lhost']
            else
              lhost = Rex::Socket.source_address(rhost)
            end

            # IPv6 specific fixups
            if ipv6
              # Force the listener to always bind to the ANY IPv6 address
              mod.datastore['ReverseListenerBindAddress'] = '::'
            end

            mod.datastore['LHOST'] = lhost

            mod.datastore['EnableStageEncoding'] = self.datastore['EnableStageEncoding']

            return
          end
        end

        print_error("No reverse connect payloads available for #{mod.fullname}")

        # Only admit defeat if the user specifically chose bind/reverse, otherwise fallthrough to bind
        if ['reverse', 'bind'].include?( datastore['PAYLOAD_METHOD'] )
          return
        end
      end


      # Handle bind connections
      if conn == :bind
        pref = compatible_payloads('bind', ipv6)

        # Maybe this was manually launched?
        if not hinf
          # Only print this if its not our fake placeholder host
          if rhost != "50.50.50.50"
            print_status("Choosing a random listener since we have no host information for this target")
          end

          # Choose a random port from the specified range
          mod.datastore['LPORT'] = @lport_mapper.find_usable_lport(ipv6).to_s

          pref.each do |n|
            if(pset.include?(n))
              mod.datastore['PAYLOAD'] = n
              return
            end
          end
          print_error("No bind payloads available for #{mod.fullname}")
          return
        end

        @bind_port_table ||= {}

        if ! @bind_port_table[rhost]
          # Create a list of all allowed ports on the target
          closed = []; opened = []; filtered = [];
          hinf.services.where(proto: 'tcp', host_id: hinf[:id]).each do |s|
            case s.state
            when 'open'
              opened << s.port
            when 'closed'
              closed << s.port
            when 'filtered'
              filtered << s.port
            end
          end

          print_status("Host #{rhost} has #{opened.length} open ports, #{closed.length} closed ports, and #{filtered.length} filtered ports")

          @bind_port_table[rhost] = [opened, closed, filtered]
        end

        opened, closed, filtered = @bind_port_table[rhost]

        # Closed ports indicate all other ports are filtered or in use
        if closed.length > 0
          mod.datastore['LPORT'] = closed[ rand(closed.length) ].to_s
          print_status("Using closed port #{mod.datastore['LPORT']} for #{rhost} due to firewall rules")
          pref.each do |n|
            if(pset.include?(n))
              mod.datastore['PAYLOAD'] = n
              return
            end
          end
          print_error("No bind payloads available for #{mod.fullname}")
        end

        ports  = configure_allowed_ports
        ports -= filtered
        ports -= opened

        pref.each do |n|
          if(pset.include?(n))
            mod.datastore['PAYLOAD'] = n
            mod.datastore['LPORT']   = ports[ rand(ports.length) ].to_s
            print_status("Using a random high port (#{mod.datastore['LPORT']}) for #{rhost}")
            mod.datastore['EnableStageEncoding'] = self.datastore['EnableStageEncoding']
            return
          end
        end

        print_error("No bind payloads available for #{mod.fullname}")
        return
      end

      print_error("No payloads were compatible with #{mod.fullname}")
    }
  end

  # This method is used to configure SRVPORT for exploits that need a dynamic listener
  # for the callback process. The PHP RFI modules are one example of this.
  def configure_exploit_callback(mod, rhost)

    return if not mod.datastore['SRVPORT']

    conn = get_payload_method(rhost)

    # Fail here because the exploit will not work
    if conn == :bind
      print_error("Fatal: Could not select a callback port when bind connections are specified")
      return
    end

    lport = find_usable_lport( Rex::Socket.is_ipv6?(rhost) )
    if not lport
      print_error("Fatal: Could not find a viable callback port")
      return
    end

    # Configure the socket
    mod.datastore['SRVPORT'] = lport.to_s
  end

  def configure_allowed_ports(lport_range=nil)
    @lport_mapper.allowed_ports = (lport_range || datastore['PAYLOAD_PORTS'] || "1024-65535")
    @lport_mapper.allowed_ports.dup
  end

  # returns an array of compatible payloads for the connection type, ipv4/ipv6, and payload type
  def compatible_payloads(connection_type, ipv6)
    payload_map = {
      'bind' => {
        'meterpreter 64-bit' => {
          'ipv4' => %w(
                windows/x64/meterpreter/bind_tcp
                linux/x64/meterpreter/bind_tcp
              ),
          'ipv6' => %w(
                windows/x64/meterpreter/bind_ipv6_tcp
              ),
          'dual' => %w(
          )
        },
        'meterpreter' => {
          'ipv4' => %w(
                windows/meterpreter/bind_tcp
                java/meterpreter/bind_tcp
                php/meterpreter/bind_tcp
                windows/meterpreter/bind_nonx_tcp
                linux/x86/meterpreter/bind_tcp
                linux/armle/meterpreter/bind_tcp
              ),
          'ipv6' => %w(
                windows/meterpreter/bind_ipv6_tcp
                php/meterpreter/bind_ipv6_tcp
                linux/x86/meterpreter/bind_ipv6_tcp
              ),
          'dual' => %w(
          )
        },
        'powershell' => {
          'dual' => %w(
                windows/powershell_bind_tcp
                windows/x64/powershell_bind_tcp
                cmd/windows/powershell_bind_tcp
              ),
          'ipv4' => [],
          'ipv6' => []
        },
        'command shell' => {
          'ipv4' => %w(
                ruby/shell_bind_tcp
                cmd/unix/interact
                cmd/unix/bind_perl
                cmd/unix/bind_inetd
                cmd/unix/bind_netcat
                cmd/unix/bind_ruby
                windows/shell/bind_tcp
                windows/x64/shell/bind_tcp
                generic/shell_bind_tcp
              ),
          'ipv6' => %w(
                bsd/x86/shell_bind_tcp_ipv6
                bsd/x86/shell/bind_ipv6_tcp
                php/bind_php_ipv6
                php/bind_perl_ipv6
                ruby/shell_bind_tcp_ipv6
                cmd/unix/interact
                cmd/unix/bind_perl_ipv6
                cmd/unix/bind_netcat_ipv6
                cmd/unix/bind_ruby_ipv6
                windows/shell/bind_ipv6_tcp
                windows/x64/shell/bind_ipv6_tcp
              ),
          'dual' => %w(

          )
        }
      },
      'reverse' => {
        'meterpreter 64-bit' => {
          'ipv4' => %w(
                windows/x64/meterpreter/reverse_tcp
                linux/x64/meterpreter/reverse_tcp
              ),
          'ipv6' => %w(
                windows/x64/meterpreter_reverse_ipv6_tcp
              ),
          'dual' => %w(
                windows/x64/meterpreter/reverse_http
                windows/x64/meterpreter/reverse_https
              )
        },
        'meterpreter' => {
          'ipv4' => %w(
                windows/meterpreter/reverse_tcp
                windows/meterpreter/reverse_nonx_tcp
                windows/meterpreter/reverse_ord_tcp
                linux/x86/meterpreter/reverse_tcp
                linux/armle/meterpreter/reverse_tcp
              ),
          'ipv6' => %w(
                windows/meterpreter/reverse_ipv6_tcp
                linux/x86/meterpreter/reverse_ipv6_tcp
              ),
          'dual' => %w(
                java/meterpreter/reverse_tcp
                php/meterpreter/reverse_tcp
                php/meterpreter_reverse_tcp
                python/meterpreter/reverse_tcp
                windows/meterpreter/reverse_http
                windows/meterpreter/reverse_https
              )
        },
        'powershell' => {
          'dual' => %w(
                windows/powershell_reverse_tcp
                windows/x64/powershell_reverse_tcp
                cmd/windows/powershell_reverse_tcp
              ),
          'ipv4' => [],
          'ipv6' => []
        },
        'command shell' => {
          'ipv4' => %w(
                windows/shell/reverse_tcp
                generic/shell_reverse_tcp
              ),
          'ipv6' => %w(
                bsd/x86/shell_reverse_tcp_ipv6
                bsd/x86/shell/reverse_ipv6_tcp
                windows/shell/reverse_ipv6_tcp
              ),
          'dual' => %w(
                cmd/unix/interact
                cmd/unix/reverse
                cmd/unix/reverse_perl
                cmd/unix/reverse_netcat
                cmd/unix/reverse_bash
                php/reverse_tcp
                php/reverse_perl
                ruby/shell_reverse_tcp
              )
        }
      }
    }
    return [] unless datastore['PAYLOAD_TYPE']
    payload_type = datastore['PAYLOAD_TYPE'].downcase
    proto = ipv6 ? 'ipv6' : 'ipv4'
    payload_map[connection_type][payload_type][proto] +
      payload_map[connection_type][payload_type]['dual'] +
      payload_map[connection_type]['meterpreter']['dual'] |
      payload_map[connection_type]['meterpreter'][proto]
  end

end
end
end
end
