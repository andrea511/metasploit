#
#  Gems
#

require 'active_support/core_ext/module/delegation'
require 'action_mailer_sender'
require 'timeout'

#
# Project
#

require 'metasploit/pro/engine/command'
require 'metasploit/pro/engine/command/base'

require 'metasploit/framework/database'

# Based on pattern used for lib/rails/commands in the railties gem.
class Metasploit::Pro::Engine::Command::Service < Metasploit::Pro::Engine::Command::Base
  #
  # Instance Methods
  #

  # Starts the RPC service.  Optionally enters console mode if the (-c/--console) option is set on the command line.
  #
  # @return [void]
  def start
    name_process
    write_pid_file
    ensure_root_user!
    start_child_servers
    announce
    create_alt_db unless Rails.env.test?

    # Start the rpc service even for console mode
    rpc_service

    # mitigate MS-6243
    # this should only need to be once unless a backup is restored?
    process_all_serialized

    # Spawn a console or simply wait for the service to exit
    if config.console.run
      # Flush arguments off ARGV so irb will load properly
      while ARGV.length > 0
        ARGV.shift
      end

      console_driver = Msf::Ui::Console::Driver.new(
          "%undmsfpro%clr",
          Msf::Ui::Console::Driver::DefaultPromptChar,
          {
              'Framework' => framework
          }
      )
      console_driver.run
    else
      update_defunct_tasks!
      TaskChain.cleanup!
      SocialEngineering::CampaignsCleaner.cleanup!
      Apps::AppRunsCleaner.cleanup!

      # Ready is printed to the console so that developer knows when
      $stdout.puts 'Ready'

      rpc_service.wait
    end
  end

  private

  # Clean up any old / defunct tasks
  # setting anything that was 'running' before to be 'interrupted'
  def update_defunct_tasks!
    # the table may not exist if the migrations have not run yet.
    # if the migrations have not run then there's no way to have defunct tasks, so just skip.
    if Mdm::Task.table_exists?
      Mdm::Task.where(state: Mdm::Task::RUNNING).each do |mdm_task|
        mdm_task.interrupt!
      end
    end
  end

  def announce
    if !!config.ssl
      ssl_label = 'SSL'
    else
      ssl_label = 'NO SSL'
    end

    server_configuration = config.server
    server_label = "#{server_configuration.host}:#{server_configuration.port}"

    $stdout.sync = true unless Rails.env.production?

    # Print host, address, and URI to stdout to mimic stdout output from rails server instead of logging.
    $stdout.puts "Metasploit Pro Service (#{server_label} (#{ssl_label}))"
    $stdout.puts "Rails Environment: #{Rails.env}"
    $stdout.puts "URI: #{config.uri}"
  end

  def build_module_cache
    framework_database_connect

    # Build the module cache in a background thread
    framework.threads.spawn("ModuleCacheBuilder", true) do
      framework.modules.refresh_cache_from_module_files
    end
  end

  delegate :config,
           :framework,
           :instrument,
           :platform,
           :root,
           to: :application

  def configure_file_permissions
    unless @file_permissions_configured
      # Permissive umask for task logs
      File.umask(022)

      # Set the file permissions when not running on Windows
      if (not platform.win32? and
          root.parent.parent.parent.join('apps').directory?)
        instrument do
          root_entities = ['license', 'license.log', 'certs', 'config']
          root_entities.each do |entity|
            entity_pathname = root.join(entity)

            if entity_pathname.exist?
              entity_pathname.chmod(0700)
            end
          end

          daemon_root_engine_entities = ['tmp']
          daemon_root_engine_entities.each do |entity|
            entity_pathname = root.join(entity)

            # Pathname#chown doesn't support name, only uid and gid, so use FileUtils#chown, which does support names
            FileUtils.chown 'daemon', 'root', entity_pathname.to_s

            entity_pathname.chmod(0750)
          end

          daemon_root_pro_entities = [
              'campaign_files',
              'cred_files',
              'export',
              'loot',
              'log',
              'reports',
              'ssl_certs',
              'tasks',
              'rc_scripts',
              File.join('engine', 'job_config'),
              File.join('wkhtmltoimage'), # This needs to be executable in DJ
              File.join('reports', 'social_engineering', 'se_webpage_previews'),
              File.join('ui', 'config', 'database.yml'),
              File.join('ui', 'public', 'uploads'),
              File.join('ui', 'tmp'),
              # CarrierWave tmp
              File.join('ui', 'public', 'uploads', 'tmp'),
              'backups'
          ]
          daemon_root_pro_entities.each do |entity|
            entity_pathname = Rails.application.root.parent.join(entity)

            # Ensure that the directory exists so we can set the
            # permissions properly:
            unless entity_pathname.exist?
              FileUtils.mkdir_p(entity_pathname)
            end

            # Pathname#chown doesn't support name, only uid and gid, so
            # use FileUtils#chown, which does support names:
            entity_path = entity_pathname.to_path
            FileUtils.chown_R 'daemon', 'root', entity_path
            FileUtils.chmod_R 0750, entity_path
          end

          [
            Rails.application.root.parent.join('ui', 'tmp', 'secret_key_base.txt'),
            Rails.application.root.parent.join('ui', 'config', 'secrets.yml')
          ].each do |secrets_file|
            if secrets_file.exist?
              FileUtils.chown 'daemon', 'root', secrets_file.to_path
            end
          end

          script_glob = Rails.application.root.join('script', '*')
          Dir.glob(script_glob) do |script_path|
            FileUtils.chmod(0755, script_path)
          end

          framework_data_pathname = Metasploit::Framework.root.join('data')
          framework_data_path = framework_data_pathname.to_s
          FileUtils.chmod_R 0755, framework_data_path

          framework_scripts_glob = Metasploit::Framework.root.join('msf*')
          Dir.glob(framework_scripts_glob) do |script_path|
            FileUtils.chmod(0755, script_path)
          end

          Rails.application.root.parent.chmod(0755)
        end
      end

      @file_permissions_configured = true
    end
  end

  def ensure_root_user!
    # Check process id, bail out if not root in production
    if Rails.env.production?
      if Process.uid != 0
        Rails.logger.fatal('Process not running as root!')

        exit(1)
      else
        Rails.logger.warn(
            "This process runs as root (in production).  " \
              "It listens at #{config.server.host}:#{config.server.port}/tcp.  " \
              "Protect it accordingly!"
        )
      end
    end
  end

  def framework_database_connect
    instrument do
      until framework.db.connect(ApplicationRecord.connection_db_config.configuration_hash)
        config = ApplicationRecord.connection_db_config.configuration_hash.select { |k,v| k != 'password' } # don't print password
        Rails.logger.error("DB Error: #{framework.db.error} #{config.inspect} #{framework.db.error.backtrace}")

        sleep_time = 15
        Rails.logger.info("Sleeping #{sleep_time} seconds and trying to reconnect...")
        sleep(sleep_time)
      end
    end
  end

  def name_process
    $0 = 'prosvc'
  end

  def rpc_service
    unless @rpc_service
      build_module_cache
      synchronize_token

      instrument do
        timestamp = Time.now.utc.to_i
        @rpc_service = ::Msf::RPC::Service.new(
            framework,
            {
                :host => config.server.host,
                :port => config.server.port,
                :uri => config.uri,
                :ssl => config.ssl,
                :tokens => {
                    config.token => [
                        'prosvc',
                        timestamp,
                        timestamp,
                        true
                    ]
                },
                :tasks => ::Pro::TaskContainer.new
            }
        )

        metasploit_pro_engine_rpc = Metasploit::Pro::Engine::Rpc.new(@rpc_service)
        @rpc_service.add_handler('pro', metasploit_pro_engine_rpc)

        # Register our main worker thread
        framework.threads.register(Thread.current, 'ProSvc', true)

        begin
          framework.db.update_all_module_details
        rescue Exception => e
          elog("Error importing modules into database: \n #{e.message} \n #{e.backtrace.join("\n")} ")
        end

        # Start the actual service
        @rpc_service.start

        # Give the background services time to initialize
        until (@rpc_service.service and
            @rpc_service.service.listener and
            @rpc_service.service.listener.listener_thread and
            @rpc_service.service.listener.listener_thread.status == 'sleep')
          select(nil, nil, nil, 0.25)
        end

        # Update the background threads and mark as critical
        framework.threads.update(@rpc_service.service.listener.listener_thread, 'ProSrv-Listener', true)
        framework.threads.update(@rpc_service.service.listener.clients_thread, 'ProSrv-ClientMonitor', true)

        # Bump their priorities to the highest level
        @rpc_service.service.listener.listener_thread.priority = 30
        @rpc_service.service.listener.clients_thread.priority = 30

        # @note this starts a background thread.  IT IS NOT DEAD CODE.
        ::Pro::BackgroundDaemon.new(framework)
      end
    end

    @rpc_service
  end

  def start_child_servers
    configure_file_permissions

    start_nada_proxy
    start_nginx
  end

  def start_nada_proxy
    if Rails.env.development?
      instrument do
        framework.threads.spawn("nada_proxy", false, "auxiliary/pro/web/nada_proxy") do |module_name|
          Thread.current.priority = -5
          begin
            mod = framework.modules.create(module_name)
            mod.run_simple
          rescue ::Exception => e
            Rails.logger.error(e)
          end
        end
      end
    end
  end

  def start_nginx
    nginx = ::Pro::Nginx.new
    nginx.start()
  end

  def synchronize_token
    unless config.token
      pathname = root.join('tmp', 'servicekey.txt')

      if pathname.size?
        config.token = pathname.read
      else
        token = Rex::Text.rand_text_alphanumeric(32)
        config.token = token

        pathname.open('wb') do |f|
          f.write(token)
        end
      end

      # Directory permissions are used to control access
      pathname.chmod(0644)

      Rails.logger.info "Service token stored in #{pathname}..."
    end
  end

  def write_pid_file
    pid_pathname = root.join('tmp', "#{$0}.pid")

    pid_pathname.open('wb') do |f|
      f.puts Process.pid
    end
  end

  def create_alt_db
    root = File.expand_path(File.join(__FILE__, "..", "..", "..", "..", "..", "..", "..", "..", ".."))
    properties = {}
    if Rails.env.production?
      File.open(File.join(root, 'properties.ini')) do |io|
        io.each do |line|
          if line[0] != '[' && line[-1] != ']' && !line.strip.empty?
            properties[line.split('=', 2).first.strip] = line.split('=', 2).last.strip
          end
        end
      end
    else
      db_config = Rails.configuration.database_configuration[Rails.env]
      properties['postgres_binary_directory'] = File.dirname(`which pg_isready`.chomp)
      properties['postgres_root_password'] = db_config['password']
      properties['username'] = db_config['username']
      properties['postgres_port'] = db_config['port']
      properties['database'] = db_config['database']
    end

    postgres_bin = properties['postgres_binary_directory']
    postgres_password = properties['postgres_root_password']
    postgres_user = Rails.env.production? ? 'postgres' : properties['username']
    postgres_port = properties['postgres_port']
    postgres_db = Rails.env.production? ? 'msf3' : properties['database']
    postgres_db_alt = postgres_db + "_alt"
    postgres_bin_extension = (RUBY_PLATFORM =~ /^win|mingw/ ? '.exe' : nil)
    command_path = File.join(postgres_bin, "psql#{postgres_bin_extension}")

    return 'properties.ini not set' if (postgres_bin.nil? || postgres_password.nil? || postgres_port.nil?)

    pg_status = nil
    begin
      Timeout::timeout(30) do
        while (pg_status =~ /accepting/i).nil?
          pg_status = `#{File.join(postgres_bin, 'pg_isready')}#{postgres_bin_extension} --port=#{postgres_port}`
          sleep 1
        end
      end
    rescue Timeout::Error
      return 'Unable to start postgres'
    end

    db_exists = false

    IO.popen([{'PGPASSWORD' => postgres_password}, command_path, '-U', postgres_user, "--port=#{postgres_port}", 'postgres', err: [:child, :out]], "r+") do |io|
      io.puts("SELECT 1 FROM pg_database WHERE datname='#{postgres_db_alt}';")
      sleep 1
      3.times { db_exists = io.gets.strip == "1"}
    end

    unless db_exists
      IO.popen([{'PGPASSWORD' => postgres_password}, command_path, '-U', postgres_user, "--port=#{postgres_port}", 'postgres', err: [:child, :out]], "r+") do |io|
        io.puts("CREATE DATABASE #{postgres_db_alt};")
        sleep 1
        io.gets
        io.puts("ALTER DATABASE #{postgres_db_alt} owner to #{properties['rapid7_database_user']};")
        sleep 1
        io.gets
      end
    end
  end

  def process_all_serialized
    return unless ::Mdm::Event.where(name: 'ActionController::Parameters Migrated').count == 0
    migrator = Rex::ThreadFactory.spawn("ActionController::Parameters Migrator", false) do
      serialized_params = {
          Mdm::Event => [ :info ],
          Mdm::Listener => [ :options ],
          Mdm::Loot => [ :data ],
          Mdm::Macro => [ :actions, :prefs ],
          Mdm::NexposeConsole => [ :cached_sites ],
          Mdm::Note => [ :data ],
          Mdm::Session => [ :datastore ],
          Mdm::Task => [ :options, :result, :settings ],
          Mdm::User => [ :prefs ],
          Mdm::WebForm => [ :params ],
          Mdm::WebPage => [ :headers ],
          Mdm::WebSite => [ :options ],
          Mdm::WebVuln => [ :params ]
      }
      serialized_params.each do |klass, params|
        params.each do |param|
          klass.find_each do |obj|
            extracted_value = obj.send(param)
            if !extracted_value.blank? && extracted_value.kind_of?(String)
              begin
                updated_settings = attempt_rails_decode(extracted_value)
                unless updated_settings.nil?
                  obj.send("#{param}=", updated_settings)
                  obj.save
                end
              rescue
                # noop
              end
            end
          end
        end
      end
      ::Mdm::Event.create( { name: 'ActionController::Parameters Migrated', username: 'system' })
    end

    migrator.priority = -10
    migrator
  end

  def attempt_rails_decode(serialized)
    marshaled = serialized.unpack('m').first
    return nil unless marshaled.include?("!ActionController::Parameters")
    marshaled = marshaled.gsub('!ActionController::Parameters', '-ActiveSupport::HashWithIndifferentAccess')
    Marshal.load(marshaled)
  end
end
