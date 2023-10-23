begin
  # Try Pro::Application first as it won't autoload, so if it doesn't raise a NameError, then this must be called
  # from pro/ui
  engine = Pro::Application
rescue NameError
  engine = Metasploit::Pro::UI::Engine
else
  # configuration that is only meant for UI as an application and not shared between engine and ui.
  Pro::Application.configure do
    # Don't fallback to assets pipeline if a precompiled asset is missed
    config.assets.compile = false
    # Compress JavaScripts and CSS
    # set to false to avoid minification error
    config.assets.compress = false
    # Generate digests for assets URLs
    config.assets.digest = true

    # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
    # Ensure we don't compile dev-only assets (like watch files)
    config.assets.precompile << Proc.new do |path|
      path.end_with? '.css', '.js' and not path.end_with? '.dev.js', '.dev.css'
    end
  end
end

engine.configure do

  $stdout.sync = true
  # Settings specified here will take precedence over those in config/application.rb

  # The test environment is used exclusively to run your application's
  # test suite.  You never need to work with it otherwise.  Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs.  Don't rely on the data there!

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection = false
  # Disable caching
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  # Metasploit::Pro::UI::Engine doesn't use action_mailer, so skip its config
  if config.respond_to? :action_mailer
    # Tell Action Mailer not to deliver emails to the real world.
    # The :test delivery method accumulates sent emails in the
    # ActionMailer::Base.deliveries array.
    config.action_mailer.delivery_method = :test
  end

  # Cache classes to mimic production mode so tests test production environment setup.
  config.cache_classes = true

  # Show full error reports
  config.consider_all_requests_local = true

  # Configure static asset server for tests
  config.serve_static_files = true

  # Cache-Control for performance
  config.static_cache_control = "public, max-age=3600"

  config.eager_load = false
  
  if ENV['SLOW']
    config.middleware.use(Rack::Delay, delay: -> (request) {
      # If you would like to customize the delay by request type:
      # if request.get?
      #   [2000]
      # elsif request.post?
      #   [2000]
      # elsif request.xhr?
      #   [2000]
      # else
      #   [1500]
      # end
      [2000] # milliseconds
      })
  end

  # Opt-in to the upcoming Rails 5 behavior of allowing raises inside a transactional callback
  # See http://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#error-handling-in-transaction-callbacks
end
