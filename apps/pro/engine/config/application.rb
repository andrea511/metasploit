#
# Standard Library
#

require 'pathname'

# project
require Pathname.new(__FILE__).expand_path.parent.join('boot')

# gem
require 'active_record/railtie'

Bundler.require(*Rails.groups)

#
# Gems
#

require 'msf/base/simple/framework'
require 'msf/core/rpc/v10/service'
require 'metasploit/framework/engine'
require 'metasploit/pro/ui/engine'
require 'metasploit/pro/ui/platform'

#
# Project
#

require 'metasploit/pro/engine'
require 'metasploit/pro/engine/rpc'
require 'pro/background_daemon'
require 'pro/hooks'
require 'pro/nginx'
require 'pro/tasks'

module Metasploit
  module Pro
    module Engine
      class Application < Rails::Application
        require 'metasploit/pro/engine/application/notifications'

        include Metasploit::Pro::Engine::Application::Notifications
        include Metasploit::Pro::UI::Platform

        #
        # default config settings
        #

        Metasploit::Pro::Engine::Configuration.defaults!(config)

        # Allows [Symbol, Mdm::Workspace, Report] in yaml, this is currently used in `serialized_prefs` and various other classes
        config.active_record.yaml_column_permitted_classes = [ Range,
                                                               Set,
                                                               Symbol,
                                                               Time,
                                                               "ActionController::Parameters".to_sym,
                                                               "ActiveModel::Attribute::FromDatabase".to_sym,
                                                               "ActiveModel::Attribute::FromUser".to_sym,
                                                               "ActiveModel::Attribute::WithCastValue".to_sym,
                                                               "ActiveModel::Type::Boolean".to_sym,
                                                               "ActiveModel::Type::Integer".to_sym,
                                                               "ActiveModel::Type::String".to_sym,
                                                               "ActiveRecord::Coders::JSON".to_sym,
                                                               "ActiveSupport::TimeWithZone".to_sym,
                                                               "ActiveSupport::TimeZone".to_sym,
                                                               "ActiveRecord::Type::Serialized".to_sym,
                                                               "ActiveRecord::Type::Text".to_sym,
                                                               "ActiveSupport::HashWithIndifferentAccess".to_sym,
                                                               "Mdm::Workspace".to_sym,
                                                               "MsfModule".to_sym,
                                                               "Report".to_sym,
                                                               "WEBrick::Cookie".to_sym,
                                                             ]

        config.cache_classes = true
        config.eager_load = true
        config.paths.add 'app/concerns', autoload: true

        config.paths.add 'config/database', with: Metasploit::Pro::UI::Engine.root.join('config', 'database.yml')

        config.paths.add 'data/meterpreter',
                         glob: '**/ext_*',
                         # :with overrides path (positional argument) so that data directory can remain at pro/data
                         # instead of the pro/engine/data that metasploit-framework would expect if `:with` was not
                         # given
                         with: File.join('..', 'data', 'meterpreter')

        config.paths.add 'modules',
                         # :with overrides path (positional argument) so that modules directory can remain at
                         # pro/modules instead of the pro/engine/modules that metasploit-framework would expect if
                         # `:with` was not given
                         with: File.join('..', 'modules')

        config.paths.add 'license'
        config.paths.add 'loot',
                         with: File.join('..', 'loot')
        config.paths.add 'reports',
                         with: File.join('..', 'reports')
        config.paths.add 'tasks',
                         with: File.join('..', 'tasks')
        config.load_defaults 7.0
        config.autoloader = :zeitwerk
        config.enable_dependency_loading = true


        config.after_initialize do
          AuditLogger.application "Metasploit Pro Service started."
        end

        at_exit do
          begin
            # Re-open AuditLogger for Win production usage
            AuditLogger.new(File.join(Rails.root, 'log', 'audit.log'))
            AuditLogger.application "Metasploit Pro Service stopped."
            AuditLogger.logger.close
          rescue
            nil
          end
        end

        #
        # `initializer`s
        #

        initializer 'metasploit_pro_engine.set_db_structure' do
          ENV['DB_STRUCTURE'] = Metasploit::Pro::UI::Engine.root.join('db', 'structure.sql').to_path
        end

        initializer 'metasploit_pro_engine.trap_term' do
          def cleanup_and_exit
            pid_file = File.join('tmp', 'prosvc.pid')
            File.delete(pid_file) if File.exist? pid_file
            exit(0)
          end

          Signal.trap("TERM") do
            cleanup_and_exit()
          end
          Signal.trap("INT") do
            cleanup_and_exit()
          end
        end

        initializer 'metasploit_pro_engine.normalize_database_configuration', before: 'active_record.initialize_database' do
          config.database_configuration.each_value do |hash|
            pool = hash['pool'].to_i

            if pool > Metasploit::Pro::Engine::Database::MAX_POOL
              hash['pool'] = Metasploit::Pro::Engine::Database::MAX_POOL
            end

            hash['wait_timeout'] ||= Metasploit::Pro::Engine::Database::DEFAULT_WAIT_TIMEOUT
          end
        end

        initializer 'metasploit_data_models.load', after: 'active_record.initialize_database' do
          require 'mdm'
        end

        initializer 'metasploit_pro_engine.patch' do
          # Pro API
          # Monkey patches Msf::Config
          require 'pro/config'
        end

        initializer :early_application_record_load, before: :setup_main_autoloader do
          # hint due to zeitwerk failing to load this early
          require 'application_record'
        end

        #
        # Instance Methods
        #

        # @return [Msf::Simple::Framework]
        def framework
          unless instance_variable_defined? :@framework
            instrument do
              config_pathname  = root.join('config')
              framework = Msf::Simple::Framework.create('ConfigDirectory' => config_pathname.to_path)
              framework.datastore['TimestampOutput'] = 'true'

              # Pro will resolve to Metasploit::Pro in this lexical scope, so prefix with Pro with :: to get top-level Pro
              # namespace
              framework.extend(::Pro::License::Product)

              license_pathname = root.join('license')
              license_path = license_pathname.to_s
              framework.esnecil_init(license_path)
              ::Pro::Hooks::Loader.start(framework)

              @framework = framework
            end
          end

          @framework
        end

      end
    end
  end
end
