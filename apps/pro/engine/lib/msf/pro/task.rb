#
# Project
#

require 'msf/pro/mime'
require 'msf/pro/locations'
require 'metasploit/pro/lport_mapper'
require 'msf/pro/task/configure'
require 'msf/pro/task/tag'

module Msf
###
#
# This module provides shared methods for top-level Pro modules
#
###
module Pro
module Task

  include Msf::Auxiliary::Report
  include Msf::Pro::Locations
  include Msf::Pro::MIME
  include Msf::Pro::Task::Configure
  include Msf::Pro::Task::Tag

  IPV4_LOCALHOST_IP = '0.0.0.0'
  IPV6_LOCALHOST_IP = '::'

  def initialize(info)
    super(info)

    register_options([
      OptAddressRange.new('WHITELIST_HOSTS', [ false, "Allowed target ranges, leave blank to allow all"]),
      OptAddressRange.new('BLACKLIST_HOSTS', [ false, "Ignored target ranges, leave blank to allow all"]),
      OptBool.new('VERBOSE', [ false, "Enable verbose module output in the task log", true]),
      OptBool.new('REALLY_VERBOSE', [ false, "Enable really verbose module output in the task log", false]),
      OptString.new('WORKSPACE', [false, "The name of the active workspace"]),
      OptString.new('PROUSER', [false, "The name of the user who launched this task"])
    ], self.class)

    register_advanced_options([
      OptBool.new('EnableReverseHTTPS', [ false, "Enable reverse_https and reverse_http stagers for configured modules", false]),
      OptBool.new('EnableReverseHTTP', [ false, "Enable reverse_http stagers for configured modules", false])
    ], self.class)

    @step_current = 0
    @lport_mapper = Metasploit::Pro::LportMapper.new
    @lport_mapper.use_rpc = false
  end


  module SessionDetectedPlatform
    attr_accessor :detected_platform
  end

  # This is used basically as a flag for report.rb#marshalize().
  class BinaryString < String
  end

  module ProScript
    attr_accessor :pro
  end

  attr_accessor :step_count, :step_current
  attr_accessor :session_total
  attr_accessor :included_hosts


  # This method memoizes an mdm task for us. If one wasn't created for this module run
  # we create one now. This allows us to test properly from the console.
  def mdm_task
    @mdm_task ||= self[:task].nil? ? Mdm::Task.create!(workspace: myworkspace) : self[:task].record
  end


  def next_step(info=nil)
    return if not @step_count
    @step_current ||= 0
    return if @step_current >= @step_count
    @step_current += 1
    if(self[:task] && @step_current != 0)
      pct = (((@step_current - 1) / (@step_count.to_f)) * 100).to_i

      self[:task].info = info || "Step #{@step_current} of #{@step_count}"

      message = "Beginning step #{@step_current}/#{@step_count} #{self[:task].info} - Progress: #{pct}%"

      if self.datastore['ParentUUID'].nil?
        self[:task].progress = pct if self.datastore['ParentUUID'].nil?
        print_good "Workspace:#{myworkspace.name} #{message}"
      else
        print_status message
      end
    end
  end

  def next_substep(spct)
    return if not @step_count
    @step_current ||= 0
    return if @step_current >= @step_count
    if(self[:task] && @step_current != 0)
      pct = (((@step_current + spct - 1) / @step_count.to_f) * 100).to_i
      self[:task].progress = pct.to_i
      # print_good("WORKSPACE=#{myworkspace.name} STEP=#{@step_current} DONE=%#{self[:task].progress} INFO=#{self[:task].info}")
    end
  end

  def task_sync
    return if not @step_count
    @step_current ||= 0
    return if @step_current >= @step_count
    if(self[:task] && @step_current !=0)
      self[:task].progress = (((@step_current - 1) / @step_count.to_f) * 100).to_i
      # time spent total
    end
  end

  def task_info
    return if not self[:task]
    self[:task].info
  end

  def task_info=(val)
    return if not self[:task]
    self[:task].info = val
  end

  def task_progress
    return if not self[:task]
    self[:task].progress
  end

  def task_progress=(val)
    return if not self[:task]
    self[:task].progress = val
  end

  def task_result
    return if not self[:task]
    self[:task].result
  end

  def task_result=(result)
    return if not self[:task]
    self[:task].result = result
  end

  def task_error
    return if not self[:task]
    self[:task].error
  end

  def task_error=(e)
    return if not self[:task]
    self[:task].error = e
  end

  def task_summary(info)
    print_status info
    self[:task].info = info
  end

  # Override
  def stop_task
  end

  def vprint_debug(msg)
    return if not datastore['REALLY_VERBOSE']
    print_status(msg)
  end

  def vprint_status(msg)
    return if not datastore['VERBOSE']
    print_status(msg)
  end

  def vprint_error(msg)
    return if not datastore['VERBOSE']
    print_error(msg)
  end

  def vprint_good(msg)
    return if not datastore['VERBOSE']
    print_good(msg)
  end

  def print_autotag_status
    if datastore['AUTOTAG_OS']
      print_status "Hosts will be automatically tagged by operating system."
    end
    if datastore['AUTOTAG_TAGS'] and not datastore['AUTOTAG_TAGS'].strip.empty?
      print_status "Hosts will be automatically tagged as: #{datastore['AUTOTAG_TAGS']}"
    end
  end

  def host_allowed?(host)
    if host.kind_of? Mdm::Host
      ip = host.address
    else
      ip = host
    end
    ((@whitelist.empty? or @whitelist[ip]) and ! @blacklist[ip])
  end

  def myworkspace
    return @myworkspace if @myworkspace
    ::ApplicationRecord.connection_pool.with_connection {
      @myworkspace = Mdm::Workspace.find_by_name(datastore['WORKSPACE']) || framework.db.workspace
    }
  end

  # XXX: Move this or have something like it into Rex instead, this is the
  # third time i've created this function at least.
  def ascii_safe_hex(str,ws=false)
    if ws
      str.gsub(/([\x00-\x20\x80-\xFF])/n){ |x| "\\x%.2x" % x.unpack("C*")[0] }
    else
      str.gsub(/([\x00-\x08\x0b\x0c\x0e-\x1f\x80-\xFF])/n){ |x| "\\x%.2x" % x.unpack("C*")[0]}
    end
  end

  # Returns the sessions that have active routes.
  def msf_routes
    sessions = framework.sessions.values.reject {|s| s.routes.nil? || s.routes.empty?}
    routes = []
    return routes if sessions.empty?
    sessions.each do |s|
      routes.concat(s.routes.split(","))
    end
    return routes.flatten.uniq
  end

  def print_routes
    unless msf_routes.empty?
      print_status "Active routes: #{msf_routes.join(", ")}"
    end
  end

  def shell_execute_script(session, path, *args)

    if not framework.sessions[session.sid]
      print_error("Could not run script #{path} on session #{session.sid}: session is not available")
      return
    end

    obj = Rex::Script::Shell.new(session, path)
    obj.extend(ProScript)
    obj.pro = self
    obj.sink = self.user_output
    obj.workspace = myworkspace

    begin
      obj.run(args)
    rescue ::Interrupt
      raise $!
    rescue ::Exception => e
      print_error("Error running script #{path} on session #{session.sid}: #{e}")
    end
  end

  #
  # Return the address associated with a session
  #
  def session_host(s)
    # Allow an IP address to be used when no session is available
    return s if s.class == ::String
    s.session_host
  end


  def shell_detect_platform(s)

    s.extend(SessionDetectedPlatform) if not s.respond_to?('detected_platform')

    # Check to see if we already know the platform
    return s.detected_platform if s.detected_platform

    print_status("Detecting the system platform for session #{s.sid} - #{session_host(s)} #{s.info.to_s}")
    # Read any pending data on the shell
    buff = s.rstream.get_once(-1, 0.01)
    if(buff and buff =~ /Windows/)
      s.detected_platform = "windows"
      return s.detected_platform
    end

    buff ||= ""

    1.upto(2) do
      temp = s.shell_command("uname -a")
      buff << temp if temp
      if (temp = s.rstream.get_once(-1, 3))
        buff << temp
      end
    end

    # Match Cisco IOS
    if (buff and buff =~ /Invalid input detected at/)
      s.detected_platform = "ios"
      return s.detected_platform
    end

    # Match Windows
    if (buff and buff =~ /or batch file/)
      s.detected_platform = "windows"
      return s.detected_platform
    end

    # Match Unix
    if (buff and buff =~ /sunos|bsd|linux|hp-?ux|aix|darwin|irix/i)
      # Output of "uname -a" on various systems, mostly gathered via google:
      #   SunOS sol9 5.11 snv_107 sun4u sparc SUNW,Sun-Blade-1000
      #   FreeBSD server.example.com 5.3-RELEASE FreeBSD 5.3-RELEASE #1: Fri Apr 29 23:04:18 EEST 2005
      #   Linux maat 2.6.32-30-generic #59-Ubuntu SMP Tue Mar 1 21:30:46 UTC 2011 x86_64 GNU/Linux
      #   HP-UX myhost A.09.01 C 9000/750 2015986034 32-user license
      #   AIX hal-ibmp610-1 2 5 0007B76A4C00
      #   Darwin macbookpro0341 10.4.0 Darwin Kernel Version 10.4.0: Fri Apr 23 18:27:12 PDT 2010; root:xnu-1504.7.4~1/RELEASE_X86_64 x86_64
      #   IRIX64 blueberry 6.5 10181058 IP27

      # Explicitly disable echo
      s.shell_command("stty -echo > /dev/null 2> /dev/null")
      s.detected_platform = "unix"
      return s.detected_platform
    end

    # Likely a device
    s.detected_platform = "device"
  end

  # We need to keep track of established sessions for both LimitSessions
  # and to ensure we don't try more than one sessions per host/service
  # (regardless of workspace) for exploit and websploit.
  # This picks up the ports the sessions are on -- but /not/ how they
  # got there. If this is a tunnel to port 22, there's no real difference,
  # but if you popped the machine on port 445 and now have a meterpreter
  # session on two arbitrary ports, I don't see a way to tell that
  # you originally got there via 445. Shouldn't matter, but this
  # may be unexpected for users?
  def find_established_sessions
    @established_sessions ||= {}
    framework.sessions.values.map do |s|
      addr,port = target_or_peer_host_and_port(s)
      uuid = s.uuid || nil
      wspace = s.workspace || nil
      @established_sessions[uuid] = [addr,wspace,port.to_i]
    end
    return @established_sessions
  end

  # Canonically determines host and port, regardless of session type. Takes
  # a framework session object, returns an array of [host,port].
  def target_or_peer_host_and_port(s)
    [s.session_host, s.session_port]
  end

  def get_payload_method(rhost)
    internet = /^(((25[0-5]|2[0-4][0-9]|19[0-1]|19[3-9]|18[0-9]|17[0-1]|17[3-9]|1[0-6][0-9]|1[1-9]|[2-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9]))|(192\.(25[0-5]|2[0-4][0-9]|16[0-7]|169|1[0-5][0-9]|1[7-9][0-9]|[1-9][0-9]|[0-9]))|(172\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|1[0-5]|3[2-9]|[4-9][0-9]|[0-9])))\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])$/

    case datastore['PAYLOAD_METHOD'].downcase
    when 'reverse'
      conn = :reverse
    when 'bind'
      conn = :bind
    else
      # The rules for automatic payload choices:
      # * Prefer reverse connections
      # * Choose bind if NAT is detected
      saddr,daddr = Rex::Socket.source_address(rhost),rhost

      # Default to reverse
      conn = :reverse

      if Rex::Socket.is_ipv4?(rhost)
        # Bind if 192.168.0.1 -> 4.4.4.4
        if daddr =~ internet and saddr !~ internet
          conn = :bind
        end
      end

      # TODO: Prefer bind for Linux targets if RHOST =~ /^fe80::/
    end
    conn
  end

  def find_usable_lport(ipv6=false, lport_range=nil)
    configure_allowed_ports(lport_range)
    @lport_mapper.find_usable_lport(ipv6)
  end

  def lport_available?(lport, ipv6=false)
    configure_allowed_ports
    @lport_mapper.lport_available?(lport,ipv6)
  end

  def ds_passthrough(mod, keys)
    keys.each do |x|
      mod.datastore[x] = datastore[x] unless datastore[x].nil?
    end
  end

end
end
end
