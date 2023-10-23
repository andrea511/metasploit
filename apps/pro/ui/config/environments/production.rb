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
  # Settings specified here will take precedence over those in config/application.rb

  # Caching is turned on
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled
  config.consider_all_requests_local = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = [I18n.default_locale]

  # See everything in the log (default is :info)
  config.log_level = :warn

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_files = true
  
  config.eager_load = true

  # Opt-in to the upcoming Rails 5 behavior of allowing raises inside a transactional callback
  # See http://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#error-handling-in-transaction-callbacks
end
