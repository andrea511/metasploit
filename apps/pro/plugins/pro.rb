##
# $Id$
##

require 'pp'
require 'pro/tasks'
require 'pro/filters'

module Msf

class ProConsoleCommandDispatcher
  include Msf::Ui::Console::CommandDispatcher
  include Metasploit::Pro::Engine::Rpc::Tasks

  # This is really a constant, but Constants are annoying in plugins
  @@brute_scopes = %w{ quick defaults normal deep known }

  @@brute_service_names = [
    "SMB", "Postgres", "DB2", "MySQL", "MSSQL", "HTTP", "HTTPS", "SSH", "Telnet",
    "FTP", "EXEC", "LOGIN", "SHELL", "VNC", "SNMP"
  ]

  @@common_opts = {
    "-h" => [ false, "Help banner"                                             ],
    "-b" => [ true,  "Host blacklist (exclude these hosts)"                    ],
    "-d" => [ false, "Dry-run. Show what would be done, but don't do anything" ]
  }

  # For commands that have payloads (bruteforce and exploit)
  @@common_payload_opts = {
    "-l"  => [ true,  "LHOST for payloads"                            ],
    "-m"  => [ true,  "Payload method: auto (default), bind, reverse" ],
  }

  def initialize(*args)
    super
    @framework = framework
    self.tasks = ::Pro::TaskContainer.new
    @user = ::Mdm::User.first
  end

  #
  # The dispatcher's name.
  #
  def name
    "Metasploit Pro"
  end

  #
  # Returns the hash of commands supported by this dispatcher.
  #
  def commands
    {
      "pro_discover"    => "Discover",
      "pro_bruteforce"  => "Bruteforce",
      "pro_exploit"     => "Exploit",
      "pro_collect"     => "Collect",
      "pro_project"     => "View or change the current Project",
      "pro_report"      => "Report",
      "pro_tasks"       => "Tasks",
      "pro_user"        => "List Pro Users",
      "version"         => "Version",
    }
  end

  ##
  # NOTE: The pro_project command and associated helpers are copy-pasted
  # directly from msf3/lib/msf/ui/console/command_dispatcher/db.rb
  # db_workspace commands with the method names changed.
  #
  # NOTE: BEGIN copy pasta

  def cmd_pro_project_help
    print_line("Usage:")
    print_line("    pro_project                  List workspaces")
    print_line("    pro_project [name]           Switch workspace")
    print_line("    pro_project -a [name] ...    Add workspace(s)")
    print_line("    pro_project -d [name] ...    Delete workspace(s)")
    print_line("    pro_project -h               Show this help information")
  end

  def cmd_pro_project(*args)
    return unless framework.db.active
    while (arg = args.shift)
      case arg
      when '-h','--help'
        cmd_pro_project_help
        return
      when '-a','--add'
        adding = true
      when '-d','--del'
        deleting = true
      else
        names ||= []
        names << arg
      end
    end

    if adding and names
      # Add workspaces
      workspace = nil
      names.each do |name|
        workspace = framework.db.add_workspace(name)
        print_status("Added workspace: #{workspace.name}")
      end
      framework.db.workspace = workspace
    elsif deleting and names
      # Delete workspaces
      names.each do |name|
        workspace = framework.db.find_workspace(name)
        if workspace.nil?
          print_error("Workspace not found: #{name}")
        elsif workspace.default?
          workspace.destroy
          workspace = framework.db.add_workspace(name)
          print_status("Deleted and recreated the default workspace")
        else
          # switch to the default workspace if we're about to delete the current one
          framework.db.workspace = framework.db.default_workspace if framework.db.workspace.name == workspace.name
          # now destroy the named workspace
          workspace.destroy
          print_status("Deleted workspace: #{name}")
        end
      end
    elsif names
      name = names.last
      # Switch workspace
      workspace = framework.db.find_workspace(name)
      if workspace
        framework.db.workspace = workspace
        print_status("Workspace: #{workspace.name}")
      else
        print_error("Workspace not found: #{name}")
        return
      end
    else
      # List workspaces
      framework.db.workspaces.each do |s|
        pad = (s.name == framework.db.workspace.name) ? "* " : "  "
        print_line(pad + s.name)
      end
    end
  end

  def cmd_pro_project_tabs(str, words)
    return [] unless framework.db.connection_established?
      if (words & ['-a','--add']).empty?
        framework.db.workspaces.map { |s|
          if s.name.match(/\s/) then
            "\"#{s.name}\""
          else
            s.name
          end
        }
      end
  end

  # END copy pasta
  ##

  #
  # Adds the Pro version to the normal framework version command.
  #
  def cmd_version(*args)
    update = framework.esnecil_product_revision
    if framework.esnecil_product_name =~ /Pro/
      print_line("Pro      : #{framework.esnecil_product_version}-#{update}")
    elsif framework.esnecil_product_name =~ /Express/
      print_line("Express  : #{framework.esnecil_product_version}-#{update}")
    else
      print_line("Community: #{framework.esnecil_product_version}-#{update}")
    end
  end

  @@collect_opts = Rex::Parser::Arguments.new(
    {
    "-h"  => [ false, "Help banner" ],
    "-f"  => [ true,  "Gather files matching this pattern" ],
    "-c"  => [ true,  "Max number of files to download with -f" ],
    "-k"  => [ true,  "Max size of individual files with -f, in kilobytes" ],
    }
  )

  def cmd_pro_collect_help
    print_line "Usage: pro_collect [options] [session IDs]"
    print_line
    print_line "Gathers evidence from the given sessions.  The following information is"
    print_line "collected when possible: basic system information including hostname and"
    print_line "OS name and version; passwords and hashes; ssh keys; and a screenshot."
    print_line "If no sessions are given, collects evidence from all open sessions."
    print_line @@collect_opts.usage
    print_line "Examples:"
    print_line "  pro_collect -f *.docx 1 3"
    print_line "  pro_collect 1"
    print_line
  end

  def cmd_pro_collect(*args)
    sids = []
    conf = {
      'DS_COLLECT_SYSINFO'        => true,
      'DS_COLLECT_PASSWD'         => true,
      'DS_COLLECT_SCREENSHOTS'    => true,
      'DS_COLLECT_SSH'            => true,
      'DS_COLLECT_FILES'          => false,
      'DS_COLLECT_FILES_PATTERN'  => 'boot.ini',
      'DS_COLLECT_FILES_COUNT'    => 10,
      'DS_COLLECT_FILES_SIZE'     => 100,
      'DS_SESSIONS'               => ""
    }

    return cmd_pro_collect_help if args.length == 0
    @@collect_opts.parse(args) { |opt, idx, val|
      case opt
      when "-h"
        cmd_pro_collect_help
        return
      when "-f"
        if not val
          print_error("#{opt} requires an argument, type 'help pro_collect' for details")
          return
        end

        conf["DS_COLLECT_FILES"] = true
        conf["DS_COLLECT_FILES_PATTERN"] = val

      when "-c"
        if not val
          print_error("#{opt} requires an argument, type 'help pro_collect' for details")
          return
        end
        conf["DS_COLLECT_FILES_COUNT"] = val.to_i
      when "-k"
        if not val
          print_error("#{opt} requires an argument, type 'help pro_collect' for details")
          return
        end
        conf["DS_COLLECT_FILES_SIZE"] = val.to_i
      else
        if opt =~ /^[-]/
          print_error "Unknown option (#{opt})"
          return
        end

        if val.to_i == 0
          print_error("Invalid session ID #{val.inspect} specified, type 'help pro_collect' for details")
          return
        end
        sids << val
      end
    }

    conf['DS_SESSIONS'] = sids.join(" ")
    print_line("Looting from #{sids.size == 1 ? "session" : "sessions"} #{sids.join(" ")}")

    conf['workspace'] = framework.db.workspace.name
    t = start_module_task(conf, "pro/collect", "Collecting")

    print_status "Started task #{t["task_id"]}" if t
    t
  end

  def cmd_pro_collect_tabs(str, words)
    tabs = []
    unless words[-1] =~ /^[-]/
      tabs = framework.sessions.keys.map { |k| k.to_s }
    end
    tabs
  end

  @@user_opts = Rex::Parser::Arguments.new(
    {
    "-h"  => [ false, "Help banner"                   ],
    "-l"  => [ false, "List all Metasploit Pro users" ],
    }
  )

  def cmd_pro_user_help
    print_line "Usage: pro_user [options] [username]"
    print_line
    print_line "If no username is given, displays the current user.  With a single argument,"
    print_line "change the current user to that username."
    print_line @@user_opts.usage
  end

  def cmd_pro_user(*args)
    other_args = []
    @@user_opts.parse(args) { |opt, idx, val|
      case opt
      when "-h"
        cmd_pro_user_help
        return
      when "-l"
        return pro_list_users
      else
        if opt =~ /^[-]/
          print_error "Unknown option (#{opt})"
          return
        end
        other_args << val
      end
    }

    case other_args.length
    when 0
      # No username arguments, just show the current user
      print_line @user.username
    when 1
      # One username argument means change the current user to the given
      # username
      ou = @user
      @user = ::Mdm::User.find_by_username(args[0])
      if @user
        print_status "Changed user to #{@user.username}"
      else
        @user = ou
        print_error("User not found")
      end
    else
      # anything else is incorrect usage
      cmd_pro_user_help
    end
  end

  def cmd_pro_user_tabs(str, words)
    users = []
    if words.length == 1 and str.length > 0
      users = ::Mdm::User.where([ "username ILIKE ?" , "#{str}%" ]).map {|u| u.username}
    elsif words.length == 1
      users = ::Mdm::User.all.map {|u| u.username}
    end
    users
  end

  @@bruteforce_opts = Rex::Parser::Arguments.new(
    {
    "-q"  => [ false, "Quit trying after a successful login"          ],
    "-s"  => [ true,  "Services to try separated by commas, e.g. 'ssh,smb'" ],
    "-sd" => [ true,  "SMB Domains separated by commas"               ],
    "-G"  => [ false, "Don't try get sessions from successful logins" ],
    "-I"  => [ false, "Don't include imported credentials"            ],
    "-K"  => [ false, "Don't include known credentials"               ],
    }.merge(@@common_opts).merge(@@common_payload_opts)
  )

  def cmd_pro_bruteforce_help
    print_line "Usage: pro_bruteforce [options] [ip addrs in nmap format] [scope]"
    print_line @@bruteforce_opts.usage
    print_line "If no addresses are given, defaults to the project's network"
    print_line "range (currently: #{framework.db.workspace[:boundary] || "<undefined>"})"
    print_line
    print_line "Scope defaults to 'normal' and can be one of: #{@@brute_scopes.join(", ")}."
    print_line
    print_line "Examples:"
    print_line "  pro_bruteforce 192.168.0.0/24 192.168.1.1-3 defaults -K -I -b 192.168.0.22 -s smb"
    print_line "  pro_bruteforce 192.168.0.22 deep -s ssh,telnet"
    print_line
  end

  def cmd_pro_bruteforce(*args)
    conf = {}
    bl   = []
    wl   = []

    return cmd_pro_bruteforce_help if args.length == 0

    conf["DS_BRUTEFORCE_SERVICES"] = ''

    @@bruteforce_opts.parse(args) { |opt, idx, val|
      case opt
      when "-h"
        cmd_pro_bruteforce_help
        return
      when "-b"
        if not val
          print_error("#{opt} requires an argument, type 'help pro_bruteforce' for details")
          return
        end
        bl << val
      when "-q"
        conf["DS_STOP_ON_SUCCESS"] = true
      when "-l"
        if not val
          print_error("#{opt} requires an argument, type 'help pro_bruteforce' for details")
          return
        end
        conf["DS_PAYLOAD_LHOST"] = val
      when "-m"
        if not val
          print_error("#{opt} requires an argument, type 'help pro_bruteforce' for details")
          return
        end
        if %w{ auto bind reverse }.include? val
          conf["DS_PAYLOAD_METHOD"] = val
        else
          print_error("Invalid payload type (should be 'auto', 'bind', or 'reverse')")
          return
        end
      when "-s"
        if not val
          print_error("#{opt} requires an argument, type 'help pro_bruteforce' for details")
          return
        end
        conf["DS_BRUTEFORCE_SERVICES"] = val.split(",").join(" ")
      when "-sd"
        if not val
          print_error("#{opt} requires an argument, type 'help pro_bruteforce' for details")
          return
        end
        conf["DS_SMB_DOMAINS"] = val
      when "-G"
        conf["DS_BRUTEFORCE_GETSESSSION"] = false
      when "-K"
        conf["DS_INCLUDE_KNOWN"] = false
      when "-I"
        conf["DS_INCLUDE_IMPORTED"] = false
      else
        if opt =~ /^[-]/
          print_error "Unknown option (#{opt})"
          return
        end

        if @@brute_scopes.include?(val)
          conf["DS_BRUTEFORCE_SCOPE"] = val
        else
          # This isn't an option or a scope value, it must be an
          # address to add to the list
          wl << val
        end
      end
    }
    conf["DS_BLACKLIST_HOSTS"] = bl.join(" ")
    conf["DS_WHITELIST_HOSTS"] = pro_whitelist(wl)
    conf["DS_BRUTEFORCE_SCOPE"] ||= "normal"


    if conf["DS_BRUTEFORCE_SERVICES"].strip.length == 0
      print_error("Specify one or target services with -s from the following options: #{@@brute_service_names.map{|x| x.downcase}.join(", ")}")
      return
    end

    if conf["DS_WHITELIST_HOSTS"].length == 0
      print_error("No target hosts have been specified and this project has no defined boundary")
      return
    end

    return if not validate_whitelist_hosts(conf)

    conf['workspace'] = framework.db.workspace.name
    t = start_module_task(conf, "pro/bruteforce", "Bruteforcing")

    # we just spawned a task, give the user a list of what's running
    #cmd_pro_tasks
    print_status "Started task #{t["task_id"]}" if t
    t
  end

  @@discover_opts = Rex::Parser::Arguments.new(
    {
    "-p"  => [ true,  "Custom ports in nmap format, e.g. 22-23,443"  ],
    "-F"  => [ false, "Don't enumerate users via Finger"             ],
    "-I"  => [ false, "Don't identify services, just do a portscan"  ],
    "-U"  => [ false, "Don't perform UDP discovery"                  ],
    "-S"  => [ false, "Don't use SNMP to discover devices"           ],
    "-su" => [ true, "Username for SMB discovery"                    ],
    "-sp" => [ true, "Password for SMB discovery"                    ],
    "-sd" => [ true, "Domain for SMB discovery"                      ],
    }.merge(@@common_opts)
  )

  def cmd_pro_discover_help
    print_line "Usage: pro_discover [options] [ip addrs in nmap format]"
    print_line @@discover_opts.usage
    print_line "If no addresses are given, defaults to the project's network"
    print_line "range (currently: #{framework.db.workspace[:boundary] || "<undefined>"})"
    print_line
    print_line "e.g.: pro_discover 192.168.1.1/24"
    print_line
  end

  def cmd_pro_discover(*args)

    conf = {}
    ips  = []
    bl   = []
    @@discover_opts.parse(args) { |opt, idx, val|
      case opt
      when "-h"
        cmd_pro_discover_help
        return
      when "-b"
        if not val
          print_error("#{opt} requires an argument, type 'help pro_discover' for details")
          return
        end
        bl << val
      when "-F"
        conf["DS_FINGER_USERS"] = false
      when "-I"
        conf["DS_IDENTIFY_SERVICES"] = false
      when "-U"
        conf["DS_UDP_PROBES"] = false
      when "-S"
        conf["DS_SNMP_SCAN"] = false
      when "-p"
        if not val
          print_error("#{opt} requires an argument, type 'help pro_discover' for details")
          return
        end
        conf["DS_PORTS_CUSTOM"] = val
      when "-su"
        if not val
          print_error("#{opt} requires an argument, type 'help pro_discover' for details")
          return
        end
        conf["DS_SMBUser"] = val
      when "-sp"
        if not val
          print_error("#{opt} requires an argument, type 'help pro_discover' for details")
          return
        end
        conf["DS_SMBPass"] = val
      when "-sd"
        if not val
          print_error("#{opt} requires an argument, type 'help pro_discover' for details")
          return
        end
        conf["DS_SMBDomain"] = val
      else
        if opt =~ /^[-]/
          print_error "Unknown option (#{opt})"
          return
        end
        # Then this isn't an option, it must be an address to add to
        # the list
        ips << val
      end
    }
    # Since these are standard options, let's see if the user set them in
    # the global datastore.
    [ "SMBUser", "SMBPass", "SMBDomain" ].each do |k|
      conf["DS_#{k}"] ||= framework.datastore[k] if framework.datastore[k]
    end

    conf["DS_BLACKLIST_HOSTS"] = bl.join(" ")
    # Annoying that disco doesn't have the same convention as other modules
    # using DS_WHITELIST_HOSTS.  Needs to be an array.
    conf["ips"] = ips.flatten.compact

    # Try to grab the project's configured addresses
    unless conf["ips"].length > 0
      conf["ips"] = [ framework.db.workspace[:boundary] ]
      conf["ips"].delete(nil)
      conf["ips"].delete("")
    end

    # If that was empty, then give up because we don't have anything to
    # scan.
    unless conf["ips"].length > 0
      print_error("No target IP addresses were specified")
      return
    end

    conf['workspace'] = framework.db.workspace.name
    t = start_module_task(conf, "pro/discover", "Discovering")

    print_status "Started task #{t["task_id"]}" if t
    t
  end

  @@exploit_opts = Rex::Parser::Arguments.new(
    {
    "-r"  => [ true,  "Minimum rank of exploits to try"               ],
    "-p"  => [ true,  "Custom ports in nmap format, e.g. 22-23,443"   ],
    "-pb" => [ true,  "Blacklist of ports to avoid, nmap format"      ],
    "-et" => [ true,  "Evasion level for TCP (1-3)"                   ],
    "-ea" => [ true,  "Evasion level for target applications (1-3)"   ],
    }.merge(@@common_opts).merge(@@common_payload_opts)
  )

  def cmd_pro_exploit_help
    print_line "Usage: pro_exploit [options] [ip addrs in nmap format]"
    print_line @@exploit_opts.usage
    print_line "If no addresses are given, defaults to the project's network"
    print_line "range (currently: #{framework.db.workspace[:boundary] || "<undefined>"})"
    print_line
  end

  def cmd_pro_exploit(*args)
    return cmd_pro_exploit_help if args.length == 0

    conf = {}
    wl   = []
    bl   = []
    @@exploit_opts.parse(args) { |opt, idx, val|
      case opt
      when "-h"
        cmd_pro_exploit_help
        return
      when "-b"
        bl << val
      when "-d"
        conf["DS_OnlyMatch"] = true
      when "-p"
        if not val
          print_error("#{opt} requires an argument, type 'help pro_exploit' for details")
          return
        end
        conf["DS_WHITELIST_PORTS"] = val
      when "-l"
        if not val
          print_error("#{opt} requires an argument, type 'help pro_exploit' for details")
          return
        end
        conf["DS_PAYLOAD_LHOST"] = val
      when "-m"
        if not val
          print_error("#{opt} requires an argument, type 'help pro_exploit' for details")
          return
        end
        if %w{ auto bind reverse }.include? val
          conf["DS_PAYLOAD_METHOD"] = val
        else
          print_error("Invalid payload type (should be 'auto', 'bind', or 'reverse')")
          return
        end
      when "-pb"
        if not val
          print_error("#{opt} requires an argument, type 'help pro_exploit' for details")
          return
        end
        conf["DS_BLACKLIST_PORTS"] = val
      when "-r"
        if not val
          print_error("#{opt} requires an argument, type 'help pro_exploit' for details")
          return
        end
        conf["DS_MinimumRank"] = val
      when "-et","-ea"
        if not val
          print_error("#{opt} requires an argument, type 'help pro_exploit' for details")
          return
        end
        unless (0..3).include?(val.to_i)
          print_error "Evasion level should be a number between 0 and 3"
          return
        end
        conf["DS_EVASION_LEVEL_TCP"] = val if opt == "-et"
        conf["DS_EVASION_LEVEL_APP"] = val if opt == "-ea"
      else
        if opt =~ /^[-]/
          print_error "Unknown option (#{opt})"
          return
        end
        # Then this isn't an option, it must be an address to add to
        # the list
        wl << val
      end
    }
    # Allow users to set MinimumRank through the global datastore.  This
    # makes pro consistent with framework when running single exploits.  If
    # it isn't set, use "great" which is the default in Pro/Express UI.
    conf["DS_MinimumRank"] ||= @framework.datastore["MinimumRank"] || "great"
    # This should just always be true.
    conf["DS_FilterByOS"] = true
    conf["DS_BLACKLIST_HOSTS"] = bl.join(" ")
    conf["DS_WHITELIST_HOSTS"] = pro_whitelist(wl)

    if conf["DS_WHITELIST_HOSTS"].length == 0
      print_error("No target hosts have been specified and this project has no defined boundary")
      return
    end

    return if not validate_whitelist_hosts(conf)

    conf['workspace'] = framework.db.workspace.name
    t = start_module_task(conf, "pro/exploit", "Exploiting")

    cmd_pro_tasks
    print_status "Started task #{t["task_id"]}" if t
    t
  end


  @@report_opts = Rex::Parser::Arguments.new(
    {
    "-h"  => [ false, "Help banner" ],
    "-r"  => [ true,  "Specify the report type to be generated (activity, audit, collected_evidence, compromised_hosts, fimsa, pci, services, webapp)" ],
    "-t"  => [ true,  "Specify the file format type(s) to be generated (pdf, word, rtf, html, or xml; you can specify multiple formats via comma-separation)" ],
    "-n"  => [ true,  "Specify a display name for the report"]
    }
  )

  def cmd_pro_report_help
    print_line "Usage: pro_report [options]"
    print_line
    print_line "Generates a report from the active workspace. The command options determine"
    print_line "the report and format type(s) generated. All hosts in the active workspace will be"
    print_line "included in the report by default. The generated report will be placed"
    print_line "into the reports directory located at the following path:"

    Rails.application.paths['reports'].existent_directories.each do |report_directory|
      print_line "    #{report_directory}"
    end

    print_line @@report_opts.usage
    print_line "e.g.:  pro_report -r \"audit\" -t pdf -n \"Audit-001\""
    print_line
  end

  # TODO: Lots more options are needed.
  def cmd_pro_report(*args)

    supported_reports = {
      "activity"           => { "default_name" => "Activity", "template" => "main.jrxml",
          "file_formats" => ["pdf", "html", "rtf"], "display_sections" => Array(1..3) },
      "audit"              => { "default_name" => "Audit", "template" => "msfxv3.jrxml",
          "file_formats" => ["pdf", "html", "word", "rtf"], "display_sections" => Array(1..8) },
      "collected_evidence" => { "default_name" => "CollectedEvidence", "template" => "msfx_loot.jrxml",
          "file_formats" => ["pdf", "html", "word", "rtf"], "display_sections" => Array(1..6) },
      "compromised_hosts"  => { "default_name" => "CompromisedandVulnerableHosts", "template" => "msfx_compromised_hosts.jrxml",
          "file_formats" => ["pdf", "html", "word", "rtf"], "display_sections" => Array(1..5) },
      "credentials"        => { "default_name" => "Credentials", "template" => "main.jrxml",
          "file_formats" => ["pdf", "html", "word", "rtf"], "display_sections" => Array(1..10) },
      "fisma"              => { "default_name" => "iFISMACompliance", "template" => "msfx_fismav1.jrxml",
          "file_formats" => ["pdf", "html", "rtf", "xml"], "display_sections" => Array(1..2) },
      "pci"                => { "default_name" => "PCICompliance", "template" => "main.jrxml",
          "file_formats" => ["pdf", "html", "rtf", "xml"], "display_sections" => Array(1..4) },
      "services"           => { "default_name" => "Services", "template" => "msfx_services.jrxml",
          "file_formats" => ["pdf", "html", "word", "rtf"], "display_sections" => Array(1..4) },
      "webapp"             => { "default_name" => "WebApplicationAssessment", "template" => "main.jrxml",
          "file_formats" => ["pdf", "html", "rtf"], "display_sections" => Array(1..7) },
    }

    mask = false
    tasklog = true
    loot_ex_shots = false
    loot_ex_passes = false
    report_type = "audit"
    report_template = supported_reports[report_type]["template"]
    report_format = [ supported_reports[report_type]["file_formats"].first ]
    report_logo = false
    use_jasper = true
    use_custom = true
    product_name = "Metasploit Pro"
    display_sections = supported_reports[report_type]["display_sections"]
    display_charts = true
    display_page_code = false
    display_web = true

    additional_params = {
      "project_name"    => framework.db.workspace.name,
      "project_created" => framework.db.workspace.created_at,
      "project_updated" => Time.now.utc.to_s,
      "user"            => @user.username
    }

    conf = {
      'DS_MaskPasswords'          => mask,
      'DS_IncludeTaskLog'         => tasklog,
      'DS_LootExcludeScreenshots' => loot_ex_shots,
      'DS_LootExcludePasswords'   => loot_ex_passes,
      'DS_JasperTemplate'         => report_template,
      'DS_REPORT_FILE_FORMAT'     => report_format,
      'DS_UseJasper'              => use_jasper,
      'DS_UseCustomReporting'     => use_custom,
      'DS_JasperProductName'      => product_name,
      'DS_JasperDbEnv'            => "production",
      'DS_JasperDisplaySections'  => display_sections.join(','),
      'DS_EnablePCIReport'        => true,
      'DS_JasperDisplayWeb'       => display_web,
      'DS_JasperDisplayCharts'    => display_charts,
      'DS_JasperDisplayPageCode'  => display_page_code,
      'DS_WHITELIST_HOSTS'        => "",
      'DS_BLACKLIST_HOSTS'        => "",
      'DS_JasperLogo'             => "",
      'DS_ADDITIONAL_PARAMS'      => additional_params
    }

    @@report_opts.parse(args) { |opt, idx, val|
      case opt
      when "-h"
        cmd_pro_report_help
        return
      when "-n"
        if not val
          print_error("#{opt} requires an argument, type 'help pro_report' for details")
          return
        end
        conf['DS_REPORT_NAME'] = val.gsub(/[^A-Za-z0-9_.-]/,"_")
      when "-r"
        if not val
          print_error("#{opt} requires an argument, type 'help pro_report' for details")
          return
        end
        val = val.downcase
        if not supported_reports.key?(val)
          print_error("Invalid report type, options include: #{supported_reports.keys.join(', ')}")
          return
        end
        report_type = val
        conf['DS_JasperDisplaySections'] = supported_reports[report_type]["display_sections"].join(',')
      when "-t"
        if not val
          print_error("#{opt} requires an argument, type 'help pro_report' for details")
          return
        end
        val = val.downcase
        val.split(',').each { |f|
          if not supported_reports[report_type]["file_formats"].include?(f)
            print_error("Invalid file format type \"#{f}\" for a #{report_type} report, options include: #{supported_reports[report_type]['file_formats'].join(', ')}")
            return
          end
        }
        conf['DS_REPORT_FILE_FORMAT'] = val.split(',')
      else
        if opt =~ /^[-]/
          print_error "Unknown option (#{opt})"
          return
        end
      end
    }

    conf['DS_REPORT_TYPE'] = report_type
    conf['DS_REPORT_NAME'] ||= "#{supported_reports[report_type]["default_name"]}-#{Time.now.utc.to_i}"

    conf['workspace'] = framework.db.workspace.name
    t = start_module_task(conf, "pro/report", "Reporting")
    print_status "Started task #{t["task_id"]} to create report \"#{conf['DS_REPORT_NAME']}\"" if t

    t
  end

  def cmd_pro_report_tabs(str, words)
    tabs = []
    unless words[-1] =~ /^[-]/
      tabs = []
    end
    tabs
  end

  @@tasks_opts = Rex::Parser::Arguments.new(
    {
    "-h"  => [ false, "Help banner" ],
    "-r"  => [ false, "Show only running tasks" ],
    "-w"  => [ true,  "Show the log from the given task id" ],
    "-k"  => [ true,  "Kill the given task id" ],
    }
  )

  def cmd_pro_tasks_help
    print_line "Usage: pro_tasks [options]"
    print_line @@tasks_opts.usage
  end

  #
  # Dump a list of running tasks.  Note: tasks started in the console are
  # unrelated to tasks started in the UI.
  #
  def cmd_pro_tasks(*args)
    only_running = false
    id = :all
    @@tasks_opts.parse(args) { |opt, idx, val|
      case opt
      when "-h"
        cmd_pro_tasks_help
        return
      when "-r"
        only_running = true
      when "-k"
        if not val
          print_error("#{opt} requires an argument, type 'help pro_tasks' for details")
          return
        end
        kill_task(val)
        return
      when "-w"
        if not val
          print_error("#{opt} requires an argument, type 'help pro_tasks' for details")
          return
        end
        tail_task_log(val)
        return
      else
        id = val
      end
    }

    # if we get here, the user wants a list
    list_tasks(id, only_running)
  end

  #
  # Validate that there are at least one of the targets is within the database
  #
  def validate_whitelist_hosts(conf)
    valid = false
    target_ranges = conf['DS_WHITELIST_HOSTS'].split(/\s+/).map{|x| Rex::Socket::RangeWalker.new(x) }
    target_ranges.each do |range|
      while (ip = range.next_ip)
        valid = framework.db.workspace.hosts.find_by_address(ip)
        break if valid
      end
      break if valid
    end

    if not valid
      print_error("No targets in the specified range have been discovered within this project")
      return false
    end
    true
  end

  attr_accessor :tasks

protected

  #
  # Largely stolen from engine/lib/pro/rpc/core.rb with the store-to-database
  # part ripped out.
  #
  def start_module_task(conf, mod, desc)
    _kick_off_module_task(conf, mod, desc, ::Pro::ProTask::START)
  end

  def _base_directory(dtype='')
    if dtype.blank?
      Rails.application.root.parent.to_path
    else
      path_name = case dtype
                    when 'loot'
                      'loot'
                    when 'report', 'task'
                      dtype.pluralize
                    else
                      raise ArgumentError, "Directories of type #{dtype} are not supported"
                  end

      directories = Rails.application.paths[path_name].existent_directories

      if directories.length > 1
        raise ArgumentError,
              "Multiple directories (#{directories.to_sentence}) are registered as #{dtype} directories."
      end

      directories.first
    end
  end

  #
  # Take the given whitelist and return a string appropriate for passing to
  # pro modules as WHITELIST_HOSTS.  If +wl+ is empty, uses the project's
  # defined boundary. If the boundary is empty, default to all live hosts
  #
  def pro_whitelist(wl)
    if wl.nil? or wl.empty?
      processed_wl = framework.db.workspace[:boundary] || ''
    else
      processed_wl = wl.join(" ")
    end

    processed_wl
  end

  def pro_list_users
    users = ::Mdm::User.all
    topts = {
      "Columns" => [ "Username", "Full Name", "Email", "Admin?" ]
    }
    tbl = Rex::Text::Table.new(topts)
    users.each do |u|
      tbl << [
        u.username,
        u.fullname || "",
        u.email    || "",
        (u.admin ? "yes" : "no").rjust("Admin?".length)
      ]
    end
    print_line
    print_line tbl.to_s
    return
  end

  def list_tasks(tid=:all, only_running=false)
    topts = {
      "Columns" => [ "Id", "Project", "Desc", "Status", "Information" ],
      "Rows" => []
    }
    if tid != :all
      unless tasks[tid]
        print_error("Unknown task #{tid}")
        return
      end
      t = tasks[tid]
      topts["Rows"] << [ tid, t.workspace, t.description, t.status, t.error || t.info || "" ]
    elsif only_running
      topts["Header"] = "Running tasks"
      tasks.reject{ |id,t| t.status != "running" }.each_pair { |id, t|
        topts["Rows"] << [ id, t.workspace, t.description, t.status, t.error || t.info || "" ]
      }
    else
      tasks.each_pair { |id, t|
        topts["Rows"] << [ id, t.workspace, t.description, t.status, t.error || t.info || "" ]
      }
    end
    tbl = Rex::Text::Table.new(topts)

    print_line
    print_line tbl.to_s
  end

  def kill_task(tid)
    t = @tasks[tid] if tid
    if t
      t.stop
    else
      print_error "No such task #{tid.inspect}"
    end
  end

  def tail_task_log(tid)
    unless tid and @tasks[tid]
      print_error("Unknown task #{tid}")
      return
    end

    t = @tasks[tid]
    offset = 0
    while true
      begin
        offset = read_file_to_end(t.path, offset)
        if t.status != "running"
          # The task has finished or errored out.  Read out anything
          # it wrote to the log while we were reading.
          read_file_to_end(t.path, offset)
          break
        end
        sleep 0.05
      rescue ::Interrupt
        break
      end
    end
  end

  def read_file_to_end(path, offset)
    File.open(path, "rb") do |f|
      f.seek(offset, IO::SEEK_SET)
      f.each_line do |line|
        offset += line.length
        line.chomp!
        print_line line if line.length > 0
      end
    end
    return offset
  end

end

###
#
# $Revision$
###
class Plugin::Pro < Msf::Plugin
  ProPrompt = "%und%clr%cyamsf-pro%clr"

  def initialize(framework, opts)
    super

    unless framework.class.ancestors.include? ::Pro::License::Product
      framework.extend(::Pro::License::Product)

      framework.esnecil_init(Rails.application.paths['license'].existent.first) rescue nil
    end

    return if framework.esnecil_invalid?
    return unless framework.esnecil_support_console?

    ::Pro::Hooks::Loader.start(framework)

    if self.opts["ConsoleDriver"]
      old_prompt = framework.datastore['Prompt'] || Msf::Ui::Console::Driver::DefaultPrompt
      framework.datastore['Prompt'] = old_prompt.sub(Msf::Ui::Console::Driver::DefaultPrompt, ProPrompt)
    end

    @disp = add_console_dispatcher(ProConsoleCommandDispatcher)
    add_meterpreter_client_search_path

    print_good("")
    print_good("Metasploit Pro extensions have been activated")
    print_good("")
  end

  def add_meterpreter_client_search_path
    ::Rex::Post::Meterpreter::Ui::Console::CommandDispatcher::Core.add_client_extension_search_path(
      ::File.expand_path(::File.join(
        File.dirname(__FILE__), "..", "engine", "lib", "rex", "post", "meterpreter", "ui", "console", "command_dispatcher"
      ))
    )
  end

  def cleanup
    remove_console_dispatcher("Metasploit Pro")
    return if not @disp
    @disp.tasks.each_value { |t| t.stop }
    if self.opts["ConsoleDriver"]
      framework.datastore['Prompt'] = framework.datastore['Prompt'].sub(ProPrompt, Msf::Ui::Console::Driver::DefaultPrompt)
    end
  end

  def name; "pro"; end
  def desc; "Provides access to Metasploit Pro features"; end

end

end

class MockTaskRecord < Hash
  @@current_id = 0
  @@mutex = Mutex.new

  def initialize
    @@mutex.synchronize do
      self[:id] = @@current_id
      @@current_id = @@current_id + 1
    end
  end

  def save!; end
  def changed?; false end

  def completed_at; self[:completed_at]; end
  def completed_at=(other); self[:completed_at] = other; end

  def description; self[:description]; end
  def description=(other); self[:description] = other; end

  def error; self[:error]; end
  def error=(other); self[:error] = other; end

  def id; self[:id]; end
  def id=(other); self[:id] = other; end

  def info; self[:info]; end
  def info=(other); self[:info] = other; end

  def progress; self[:progress]; end
  def progress=(other); self[:progress] = other; end

  def path; self[:path]; end
  def path=(other); self[:path] = other; end

  def result; self[:result]; end
  def result=(other); self[:result] = other; end

  def workspace; self[:workspace]; end
  def workspace=(other); self[:workspace] = other; end

  def module; self[:module]; end
  def module=(other); self[:module] = other; end
end

