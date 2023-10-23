Pro::Application.configure do
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

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Cache classes to mimic production mode so tests test production environment setup.
  config.cache_classes = true

  # Show full error reports
  config.consider_all_requests_local = true

  # Configure static asset server for tests
  config.serve_static_files = true

  # Cache-Control for performance
  config.static_cache_control = "public, max-age=3600"

  # Opt-in to the upcoming Rails 5 behavior of allowing raises inside a transactional callback
  # See http://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#error-handling-in-transaction-callbacks
end
