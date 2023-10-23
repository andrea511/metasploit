require File.expand_path('../boot', __FILE__)

require 'rails/all'

# we do this after Rails lib has loaded, since we need access to Rails.env
require File.expand_path('./feature_flags', File.dirname(__FILE__))

if defined?(Bundler)
  # Precompile assets before deploying to production
  Bundler.require(*Rails.groups(:assets => %w(development test)))
end

#
# Gems
#

require 'metasploit/framework/engine'

#
# Project
#

require 'metasploit/pro/ui/common_configuration'
require 'metasploit/pro/ui/platform'

module Pro
  # @note DO NOT set config.encoding.  It is handled by Metasploit::Framework::Engine
  class Application < Rails::Application
    include Metasploit::Pro::UI::CommonConfiguration
    include Metasploit::Pro::UI::Platform

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Activate observers that should always be running.
    config.active_record.observers = :running_campaign_observer,
                                     :"social_engineering/configurable_campaign_observer"

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

    # Enable the asset pipeline
    config.assets.enabled = true
    # Disable initialization when precompiling assets
    config.assets.initialize_on_precompile = true
    # Remove default behavior of loading all non-js and non-css files
    config.assets.precompile.shift
    # Explicitly register the extensions for precompile
    config.assets.precompile += [
      '*.png',  '*.gif', '*.jpg', '*.jpeg', '*.svg', '*.ico', # Images
      '*.eot',  '*.otf', '*.svc', '*.woff', '*.ttf',          # Fonts
      '*.htc',  '*.map', '*.md',  '*.yml'                     # Misc
    ]
    config.assets.precompile += %w( vendor/* )
    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

     # Custom directories with classes and modules you want to be autoloadable.
    config.paths.add 'app/presenters', eager_load: true

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [
        'social_engineering_email[smtp_password]',
        'social_engineering_email[smtp_username]',
        :SMBDomain,
        :SMBPass,
        :SMBUser,
        :cookie,
        :http_password,
        :http_username,
        :nexpose_creds_pass,
        :nexpose_creds_user,
        :nexpose_pass,
        :options,
        :pass,
        :password,
        :password_confirmation,
        :proxy_pass,
        :proxy_pass,
        :quickmode_creds,
        :smtp_pass,
        :smtp_user,
        :user
    ]

    config.generators do |g|
      g.fixture_replacement :factory_bot
    end

    config.paths.add 'lib/tasks',
                     # have to do a combined glob because the implementation in Rails::Engine expects to be able to call
                     # paths['lib/tasks'].existent, so it won't support an Array of paths.
                     glob: '{metasploit/pro/ui/,}tasks/**/*.rake',
                     # the two tasks directories have a common root in lib, so put it as the path.
                     with: 'lib',
                     eager_load: true

    config.marionette = {}
    # client side marionette application instance name
    config.marionette[:app_name] = 'Pro'
    # whether we're using base views to extend from
    config.marionette[:base_views] = true
    # are we using js-routes for url and urlRoot properties on entities?
    config.marionette[:js_routes] = false

    config.session_store :cookie_store, key: '_ui_session'

    config.load_defaults 7.0

    config.autoloader = :zeitwerk
    # temporary load fix
    config.enable_dependency_loading = true

    # Override metasploit-framework's encoding of ASCII-8BIT so assets can be loaded correctly by sprockets.
    config.before_initialize do
      encoding = 'utf-8'
      Encoding.default_external = encoding
      Encoding.default_internal = encoding
    end

    config.after_initialize do
      if $0.match(/thin/)
        AuditLogger.application "Metasploit Pro UI started."
      elsif $0.match(/worker_service/) # Win
        AuditLogger.application "Metasploit Pro Worker started."
      elsif !ARGV.grep(/metasploit_worker/).empty? # Linux
        AuditLogger.application "Metasploit Pro Worker started."
      end
    end

    at_exit do
      begin
        if $0.match(/thin/)
          AuditLogger.application "Metasploit Pro UI stopped."
        elsif $0.match(/metasploit_worker|worker_service/) # Linux | Win
          AuditLogger.application "Metasploit Pro Worker stopped."
        end
      rescue
        nil
      end
    end

    # # For the moment, silence deprecation warnings
    # ActiveSupport::Deprecation.silenced = true

    # Print deprecation notices to the stderr
    config.active_support.deprecation = :stderr

    # Load Rake tasks and perform any actions when a Rake task is executed
    rake_tasks do
      # load "path/to/my_railtie.tasks"

      # set `$rails_rake_task = true` to enable correct `wait_until_migrated` logic
      # in initializers.  If it is not set for Rake tasks, then `rake db:migrate` will not work.
      $rails_rake_task = true
    end

    config.action_controller.permit_all_parameters = false
    config.action_controller.action_on_unpermitted_parameters = :raise

    # migrate existing Marshal-serialized cookies into JSON-based format.
    config.action_dispatch.cookies_serializer = :json

    #
    # @note If an initializer declares a `:before` and the name cannot be resolved in this railtie, then `:after` will
    #   automatically be set to the last declared initializer's name, which mean that named initializers should be
    #   declared in the order they MUST be run and not alphabetically.
    #
    # `initializer`s
    #

    # @note First to ensure that no ApplicationRecord schema data is cached by any other initializer
    #
    initializer 'metasploit_pro_ui.wait_until_migrated',
                # After load concerns only so anything that is after wait_until_migrated can't accidentally
                # cache ActiveRecord associations and attributes that don't include the concerns.
                after: 'metasploit_concern.load_concerns',
                # loading before load_config_initializers ensures that when using Pro::Application, but not
                # Metasploit::Pro::UI::Engine, UI will wait for prosvc's framework to do the migration when it calls
                # `framework.db.connect`
                before: :load_config_initializers do
      # If running a rake task, don't wait for the database to be migrated because waiting would stop
      # `rake db:migrate` from working.
      unless $rails_rake_task
        # cannot rely autoload due to Rails restrictions
        require 'metasploit/database'
        require 'metasploit/database/migration_timeout_error'
        Metasploit::Database.wait_until_migrated(10.minutes)
        require 'mdm' # models are autoloaded this add them early so Zeitwerk will find the constants already in place
      end
    end


    # after wait_until_migrated (and implicitly metasploit_concern.load_concerns) so the table exists and
    # load_latest_smtp_configuration is defined.
    initializer 'metasploit_pro_ui.load_latest_smtp_configuration', after: 'metasploit_pro_ui.wait_until_migrated' do
      # the profiles table will not exist before the database is migrated
      unless $rails_rake_task
        Rails.application.configure do
          config.after_initialize do
            default_profile
            Mdm::Profile.load_latest_smtp_configuration
          end
        end
      end
    end

    initializer 'metasploit_pro_ui.register_metamodules', after: 'metasploit_pro_ui.wait_until_migrated' do
      unless $rails_rake_task
        Rails.application.configure do
          config.after_initialize do
            ::Rails::Engine.subclasses.map(&:instance).each do |engine|
              engine_config = engine.root.join("config","metamodule.yml")

              if engine_config.exist?
                begin
                  yaml = YAML.load(engine_config.open)
                  Apps::App.register_metamodule(yaml)
                rescue Psych::SyntaxError
                  puts "Metamodule Config Malformed: #{engine_config}"
                  raise
                end
              end
            end
          end
        end
      end
    end


    initializer 'metasploit_pro_ui.add_coffee_script_helpers',
                # run both for Pro::Application and `rake asset:precompile`
                group: :all do

      # Adds our coffeescript helpers to coffee.erb files
      Rails.application.config.assets.configure do |env|
        env.context_class.class_eval do
          include CoffeescriptErbHelpers
        end
      end
    end

    initializer 'metasploit_pro_ui.add_csv_format' do
      Rails.application.configure do
        config.after_initialize do
          ActionController::Renderers.add :csv do |csv, options|
          self.content_type = Mime[:csv]
          self.response_body  = csv.respond_to?(:to_csv) ? csv.to_csv : csv
          end
        end
      end
    end

    initializer 'metasploit_pro_ui.delayed_worker' do
      Rails.application.configure do
        config.after_initialize do
          config.active_job.queue_adapter = :delayed_job
          Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))
          Delayed::Worker.destroy_failed_jobs = false
          Delayed::Worker.sleep_delay = 3
          Delayed::Worker.max_attempts = 1
          Delayed::Worker.max_run_time = 60.minutes
          Delayed::Worker.read_ahead = 3
          Delayed::Worker.default_queue_name = 'default'
          Delayed::Worker.delay_jobs = !Rails.env.test?
        end
      end
    end

    initializer 'metasploit_pro_ui.formtastic' do
      Rails.application.reloader.to_prepare do
        Formtastic::Helpers::FormHelper.builder = Custom::SemanticFormBuilder
        Formtastic::FormBuilder.action_class_finder = Formtastic::ActionClassFinder
        Formtastic::FormBuilder.input_class_finder = Formtastic::InputClassFinder
      end
    end

    initializer :early_application_record_load, before: :setup_main_autoloader do
      # hint due to zeitwerk failing to load this early
      require 'application_record'
    end
  end
end


# Allow some initializers to load during asset precompiliation
# http://stackoverflow.com/questions/9235292/how-can-i-run-some-initializers-when-doing-a-rails-assetsprecompile/12700183#12700183
module AssetInitializers
  class Railtie < Rails::Railtie
    initializer "asset_initializers.initialize_rails", :group => :assets do |app|
      # order from farthest dependency to closest so the gems that define a model are searched before gems that
      # define concerns for those models to prevent the models being only loaded as a namespace Module instead of
      # an actual class

      engines = [
        Metasploit::Concern::Engine,
        Metasploit::Model::Engine,
        MetasploitDataModels::Engine,
        Metasploit::Credential::Engine,
      ]

      engines.each do |engine|
        # emulate set_load_path
        engine._all_load_paths.reverse_each do |path|
          $LOAD_PATH.unshift(path) if File.directory?(path)
        end

        $LOAD_PATH.uniq!

        # emulate set_autoload_paths
        ActiveSupport::Dependencies.autoload_paths.unshift(*engine._all_autoload_paths)
        ActiveSupport::Dependencies.autoload_once_paths.unshift(*engine._all_autoload_once_paths)
      end

      ActiveSupport::Dependencies.eager_load_paths += [
        Rails.root.join('app', 'models'),
        Rails.root.join('app', 'helpers'),
        Rails.root.join('lib')
      ]
      ActiveSupport::Dependencies.autoload_paths += [
        Rails.root.join('app', 'models'),
        Rails.root.join('app', 'helpers'),
        Rails.root.join('lib')
      ]
    end
  end
end

# Touches log files to ensure non-root users can write
class LogToucher < Rails::Railtie
  config.after_initialize do
    FileUtils.touch(Report::LOG_FILE) unless File.exist?(Report::LOG_FILE)
    FileUtils.touch(Export::LOG_FILE) unless File.exist?(Export::LOG_FILE)
  end
end

# Touches directories to ensure non-root users can write
# Needed for development, but can cause perm error in production, thus
# the rescue. In production env this is created in engine.rb
class DirToucher < Rails::Railtie
  dirs = [Rails.root.join('public', 'uploads', 'tmp'),
          Rails.root.join('..', 'reports', 'social_engineering', 'se_webpage_previews')
  ]
  config.after_initialize do
    begin
      dirs.each do |d|
        FileUtils.mkdir_p d
      end
    rescue
      nil
    end
  end
end

# For the case of upgrading to Metasploit 4.9 (which brought a new
# Report model), create a legacy_reports dir and move all the old style
# reports and exports there.
# The DB manifestations are removed by the migrations with the
# new model, so these files would otherwise be orphaned.
class LegacyReportMover < Rails::Railtie

  # Would be nice to split reports and exports into different dirs,
  # but xml, pdf, rtf, html are ambiguous.
  EXTS_MOVE = %w|docx html pdf rtf txt xml zip| # .replay.zip implied
  REPORT_DIR = File.join(Rails.root, '..', 'reports')
  REPORT_DIR_CONTENTS = Dir.glob(File.join(REPORT_DIR,'*'))
  LEGACY_DIR = File.join(REPORT_DIR, 'legacy_reports')

  config.after_initialize do
    unless legacy_handled?
      Dir.mkdir(LEGACY_DIR)

      REPORT_DIR_CONTENTS.each do |file|
        next unless File.file? file

        fname = File.basename file
        ext = File.extname(file).split('.')[1,]

        if EXTS_MOVE.member? ext
          FileUtils.mv(file, File.join(LEGACY_DIR, fname))
        end
      end
    end
  end

  def legacy_handled?
    Dir.exist?(LEGACY_DIR)
  end
end
