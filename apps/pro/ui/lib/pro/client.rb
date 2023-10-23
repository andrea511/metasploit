# This *MUST* be before msf/core since otherwise it will load the old RPC first
require 'msf/core/rpc/v10/client'
require 'timeout'
require 'metasploit/concern'


module Pro
class Client

  attr_accessor :rpc
  attr_accessor :last_error

  def initialize(opts={})
    @opts = {
      'SSL'  => false,
      'ServerPort' => 50505,
      'ServerHost' => '127.0.0.1',
      'URI'        => '/api/'
    }

    @opts.merge!(opts)

    unless @opts['Token']
      pathname = Pathname.new(__FILE__).parent.parent.parent.parent.join('engine', 'tmp', 'servicekey.txt')
      data = pathname.read
      @opts['Token'] = data
    end

    connect
  end

  def connect
    self.rpc = Msf::RPC::Client.new(
      :host => @opts['ServerHost'],
      :port => @opts['ServerPort'],
      :uri  => @opts['URI'],
      :ssl  => @opts['SSL']
    )
    rpc.token = @opts['Token']
  end

  def call(*args)
    begin
      self.rpc.call(*args)
    rescue ::Exception => e
      self.last_error = e
      raise e
    end
  end

  def close
    self.rpc.close
  end

  # Returns a thread-local Pro::Client instance.
  def self.get
    Thread.current[:pro_client] ||= Pro::Client.new
  end

  #
  # Payload Generation
  #

  def validate_classic_payload(options)
    call("pro.validate_classic_payload", options)
  end

  def generate_classic_payload(payload_id)
    call("pro.generate_classic_payload", payload_id)
  end

  def generate_dynamic_stager(payload_id)
    call("pro.generate_dynamic_stager", payload_id)
  end

  #
  # Licensing and updates
  #

  def license
    call("pro.license")
  end

  def register(product_key)
    call("pro.register", product_key)
  end

  def revert_license
    call("pro.revert_license")
  end

  def activate(conf)
    call("pro.activate", conf)
  end

  def activate_offline(path)
    call("pro.activate_offline", path)
  end

  def update_available(conf)
    call("pro.update_available", conf)
  end

  def update_install(conf)
    call("pro.update_install", conf)
  end

  def update_install_offline(path)
    call("pro.update_install_offline", path)
  end

  def update_status(conf)
    call("pro.update_status", conf)
  end

  def restart_status(conf)
    call("pro.restart_status", conf)
  end

  def update_stop(conf)
    call("pro.update_stop", conf)
  end

  def restart_service(conf)
    call("pro.restart_service", conf)
  end

  def wait_for_restart
    self.close
    sleep 2
    begin
      sleep 1
      while true
        self.connect
        break
      end
    rescue ::Exception => e
      retry
    end
  end

  def about
    {
      'core' => call("core.version"),
      'pro'  => call("pro.about"),
      'license' => call("pro.license"),
      'ruby' => { 'version' => RUBY_VERSION, 'platform' => RUBY_PLATFORM }
    }
  end

  def version
    call("core.version")
  end

  #
  # Task management
  #

  def task_stop(task_id)
    call("pro.task_stop", task_id.to_s)
  end

  def task_pause(task_id)
    call("pro.task_pause", task_id.to_s)
  end

  def task_resume(task_id)
    call("pro.task_resume", task_id.to_s)
  end

  def task_delete_log(task_id)
    call("pro.task_delete_log", task_id)
  end

  def task_list
    call("pro.task_list")
  end

  def task_wait(task_id)
    t = task_id.to_s
    r = nil
    while(true)
      r = call('pro.task_status', t)
      break if not r[t]
      break if r[t]['status'] != 'running'
      select(nil, nil, nil, 0.5)
    end

    if(r and r[t] and r[t]['status'] != 'invalid')
      call('pro.task_stop', t)
    end
  end

  #
  # Importing
  #

  def start_import(conf)
    call("pro.start_import", conf)
  end

  def validate_import_file(data)
    call("pro.validate_import_data", data)
  end

  #
  # Scanning and exploitation
  #

  def start_bruteforce(conf)
    call("pro.start_bruteforce", conf)
  end

  def start_campaign(conf)
    call("pro.start_campaign", conf)
  end

  def start_discover(conf)
    call("pro.start_discover", conf)
  end

  def start_exploit(conf)
    call("pro.start_exploit", conf)
  end

  def start_nexpose(conf)
    call("pro.start_nexpose", conf)
  end

  def start_webscan(conf)
    call("pro.start_webscan", conf)
  end

  def start_webaudit(conf)
    call("pro.start_webaudit", conf)
  end

  def start_websploit(conf)
    call("pro.start_websploit", conf)
  end

  #
  # Analysis
  #

  def analyze(conf)
    # conf:
    #   {
    #     workspace: workspace.id
    #     host: (as ip address?)
    #     payloads: [Array<>String]
    #   }
    call("db.analyze_host", conf)
  end

  def payloads_for_config(conf)
    # conf:
    #   {
    #     "DS_PAYLOAD_METHOD" => "auto"
    #     "DS_PAYLOAD_TYPE" => "meterpreter 64-bit"
    #     "DS_PAYLOAD_PORTS" => "1024-65535"
    #     "DS_EVASION_LEVEL_TCP" => 0
    #     "DS_EVASION_LEVEL_APP" => 0
    #  }
    call("pro.payloads_for_config", conf)
  end

  #
  # Post-exploitation
  #

  def start_collect(conf)
    call("pro.start_collect", conf)
  end

  def start_cleanup(conf)
    call("pro.start_cleanup", conf)
  end

  def start_upgrade_sessions(conf)
    call("pro.start_upgrade_sessions", conf)
  end

  def start_download(conf)
    call("pro.start_download", conf)
  end

  def session_list
    call("session.list")
  end

  def session_stop(id)
    call("session.stop", id)
  end

  def start_tunnel(conf)
    call("pro.start_tunnel", conf)
  end

  def start_upload(conf)
    call("pro.start_upload", conf)
  end

  def start_listener(conf)
    call("pro.start_listener", conf)
  end

  def start_replay(conf)
    call("pro.start_replay", conf)
  end

  #
  # Misc
  #



  # Start new-style Social Engineering campaign
  def start_se_campaign(conf)
    call("pro.start_se_campaign", conf)
  end

  def generate_exe(conf)
    call("pro.generate_exe", conf)
  end

  def portable_file_generate(conf)
    call("pro.portable_file_generate", conf)
  end

  def loot_delete_file(loot_id)
    call("pro.loot_delete_file", loot_id)
  end

  def loot_create(opts={})
    call("pro.loot_create", opts)
  end

  def start_vuln_validation_wizard(conf)
    call("pro.start_vuln_validation_wizard", conf)
  end

  def resume_vuln_validation_wizard(conf)
    call("pro.resume_vuln_validation_wizard", conf)
  end

  def start_scan_and_import(conf)
    call("pro.start_scan_and_import",conf)
  end

  def start_quick_pentest_wizard(conf)
    call("pro.start_quick_pentest_wizard", conf)
  end

  def start_web_app_test(conf)
    call("pro.start_web_app_test", conf)
  end

  def module_compatible_sessions(name)
    call("module.compatible_sessions", name)
  end

  def session_compatible_modules(sid)
    call("session.compatible_modules", sid)
  end

  def payload_formats
    call("pro.payload_formats")
  end

  def module_details(type)
    call("pro.modules", type)
  end

  def module_execute(type, name, options)
    call("module.execute", type, name, options)
  end

  def module_options(type, name)
    call("module.options", type, name)
  end

  def module_validate(name, options)
    call("pro.module_validate", name, options)
  end

  def start_single(conf)
    call("pro.start_single", conf)
  end

  def start_nexpose_asset_group_push(conf)
    call("pro.start_nexpose_asset_group_push", conf)
  end

  def start_nexpose_exception_push(conf)
    call("pro.start_nexpose_exception_push", conf)
  end

  def start_nexpose_exception_and_validation_push_v2(conf)
    call("pro.start_nexpose_exception_and_validation_push_v2",conf)
  end

  def lport_available?(lport,ipv6=false)
    call("pro.lport_available?", lport, ipv6)
  end

  def start_passive_network_discovery(conf)
    call("pro.start_passive_network_discovery", conf)
  end

  def start_single_password_testing(conf)
    call('pro.start_single_password_testing', conf)
  end

  def start_pass_the_hash(conf)
    call('pro.start_pass_the_hash', conf)
  end

  def start_ssh_key_testing(conf)
    call('pro.start_ssh_key_testing', conf)
  end

  def start_credential_intrusion(conf)
    call('pro.start_credential_intrusion', conf)
  end

  def start_validate_login(conf)
    call('pro.start_validate_login', conf)
  end

  def start_attempt_session(conf)
    call('pro.start_attempt_session',conf)
  end

  def start_brute_force_reuse(conf)
    call("pro.start_brute_force_reuse", conf)
  end

  def start_brute_force_quick(conf)
    call("pro.start_brute_force_quick", conf)
  end

  def meterpreter_transport_change(sid,opts)
    call("session.meterpreter_transport_change", sid, opts)
  end

  def start_sonar_import(conf)
    call("pro.start_sonar_import", conf)
  end

  def start_sonar_discovery(conf)
    call("pro.start_sonar_discovery", conf)
  end

  def start_rc_launch(conf)
    call("pro.start_rc_launch", conf)
  end

  Metasploit::Concern.run(self)
end
end
