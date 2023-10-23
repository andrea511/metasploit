module Metasploit::Pro::Engine::Rpc::Meterpreter

  require 'rex/post/meterpreter/extensions/pivot/tap/daemon/windows'

  # Return the working directory of the Meterpreter instance
  def rpc_meterpreter_getcwd(sid)
    s = _find_meterpreter_session(sid)
    {"path" => s.fs.dir.pwd}
  end

  # Change the working directory of the Meterpreter instance
  def rpc_meterpreter_chdir(sid, path)
    s = _find_meterpreter_session(sid)
    s.fs.dir.chdir(path)
    {"path" => s.fs.dir.pwd}
  end

  # List files in the specified path
  def rpc_meterpreter_list(sid, path)
    s = _find_meterpreter_session(sid)
    entries = {}
    s.fs.dir.entries_with_info(path).each do |p|
      entries[p['FileName']] = {
        'mode' => p['StatBuf'] ? p['StatBuf'].prettymode : '',
        'size' => p['StatBuf'] ? p['StatBuf'].size : '',
        'type' => p['StatBuf'] ? p['StatBuf'].ftype[0, 3] : '',
        'mtime' => p['StatBuf'] ? p['StatBuf'].mtime.utc.to_i : 0,
      }
    end
    {"entries" => entries}
  end

  # Search for files matching a particular pattern
  def rpc_meterpreter_search(sid, query)
    s = _find_meterpreter_session(sid)
    entries = []
    if query and not query.to_s.strip.empty?
      entries = s.fs.file.search(nil, query, true) rescue []
    end
    entries ||= []

    # Copy results into a hash for the return value
    entries.each do |ent|
      ent['mtime'] = ent['mtime'].to_i
    end

    {"entries" => entries}
  end

  # Delete a file with a specified path
  def rpc_meterpreter_rm(sid, path)
    s = _find_meterpreter_session(sid)

    begin
      r = s.fs.file.rm(path)
      self.framework.events.on_session_filedelete(s, path)
      {'result' => 'success'}
    rescue ::Exception => e
      {'result' => 'failure', 'error' => e.to_s}
    end
  end

  # Enumerate the system drives or root path
  def rpc_meterpreter_root_paths(sid)
    s = _find_meterpreter_session(sid)

    if s.platform =~ /windows/
      begin
        s.core.use("railgun") if not s.railgun
        bits = [s.railgun.kernel32.GetLogicalDrives()["return"]].pack("N").unpack("B32")[0].reverse
        drives = []
        letters = [*("A".."Z")]
        letters.each_index { |t| drives << letters[t] + ":\\" if bits[t, 1] == "1" }
        return {'result' => 'success', 'paths' => drives}
      rescue ::Exception => e
      end
    end

    {'result' => 'success', 'paths' => ["/"]}
  end

  # List available tunnel interfaces for VPN Pivoting
  def rpc_meterpreter_tunnel_interfaces(sid)
    s = _find_meterpreter_session(sid)
    begin

      # This pivot extension triggers a blue screen on Windows 2000. Detect and block here.
      if s.sys.config.sysinfo["OS"] =~ /Windows (NT 4\.0|2000) /
        return {'result' => 'failure', 'error' => "Unsupported target operating system"}
      end

      # On Windows installations, make sure the driver has been installed
      if RUBY_PLATFORM =~ /mingw32/
        if not Rex::Post::Meterpreter::Extensions::Pivot::Tap::Daemon::WindowsTap::WindowsTapDevice.drivers_loaded?
          return {'result' => 'failure', 'error' => "VPN Pivot drivers are not installed"}
        end
      end

      # Continue on and load the pivot extension
      s.core.use("pivot") if not s.pivot
      if not s.pivot
        return {'result' => 'failure', 'error' => "Unable to load the VPN Pivot extension"}
      end

      interfaces = s.pivot.list_interfaces
      if not interfaces
        return {'result' => 'failure', 'error' => "Unable to list interfaces"}
      end

      res = {}

      interfaces.each do |interface|
        itype = ""

        case interface['type'].to_i
          when Rex::Post::Meterpreter::Extensions::Pivot::Pivot::INTERFACE_TYPE_ETHERNET
            itype = "Ethernet (802.3)"
          when Rex::Post::Meterpreter::Extensions::Pivot::Pivot::INTERFACE_TYPE_TOKENRING
            itype = "TokenRing (802.5)"
          when Rex::Post::Meterpreter::Extensions::Pivot::Pivot::INTERFACE_TYPE_FDDI
            itype = "FDDI"
          when Rex::Post::Meterpreter::Extensions::Pivot::Pivot::INTERFACE_TYPE_WAN
            itype = "WAN"
          when Rex::Post::Meterpreter::Extensions::Pivot::Pivot::INTERFACE_TYPE_WIRELESS
            itype = "Wireless (802.11)"
          else
            itype = "Unknown"
        end

        mac = ""
        interface['physical_address'].each_byte do |b|
          mac += "%02X:" % b
        end
        mac = mac.chomp(":")

        res[interface['id'].to_s] = {
          'type' => itype,
          'mac' => mac,
          'name' => interface['name'].to_s,
          'description' => interface['description'].to_s,
          'address' => interface['ip4_address'][0].to_s,
          'netmask' => interface['ip4_subnetmask'][0].to_s,
          'gateway' => interface['ip4_gateway'].to_s,
          'dns' => interface['ip4_dns'].to_s,
          'dhcp' => interface['ip4_dhcp'].to_s,
          'bridged' => interface['bridged'] ? true : false
        }
      end

      return {'result' => 'success', 'interfaces' => res}

    rescue ::Exception => e
      return {'result' => 'failure', 'error' => e.to_s}
    end
  end

end
