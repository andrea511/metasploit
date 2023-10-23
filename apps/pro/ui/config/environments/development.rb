require 'nexpose/util'
require 'nexpose/api'
require 'nexpose/api_request'
require 'nexpose/connection'
require 'nexpose/api'
require 'nexpose/error'
require 'rexml/element'
require 'rexml/document'

begin
  # Try Pro::Application first as it won't autoload, so if it doesn't raise a NameError, then this must be called
  # from pro/ui
  engine = Pro::Application
rescue NameError
  engine = Metasploit::Pro::UI::Engine
else
  # configuration that is only meant for UI as an application and not shared between engine and ui.
  Pro::Application.configure do
    # Raise ActionMailer errors while developing
    config.action_mailer.raise_delivery_errors = true

    # Do not compress assets
    config.assets.compress = false
    # Expands the lines which load the assets
    config.assets.debug = true
    # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
    config.assets.precompile += ['*.js', '**/*.js', "*.css", "**/*.css"]
    config.assets.digest = true

  end
end

engine.configure do
  $stdout.sync = true
  # Settings specified here will take precedence over those in config/application.rb

  # Disable caching
  config.action_controller.perform_caching = false

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Show full error reports
  config.consider_all_requests_local = true

  # Prevent public/assets folder from being served
  config.serve_static_files = false
  
  config.eager_load = false

  # Opt-in to the upcoming Rails 5 behavior of allowing raises inside a transactional callback
  # See http://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#error-handling-in-transaction-callbacks
end
