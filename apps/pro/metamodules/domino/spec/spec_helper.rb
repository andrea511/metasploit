# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

require 'rubygems'
require 'bundler'
Bundler.setup(:default, :test)


app = ENV['APP']

unless app
  raise ArgumentError,
        "The APP environment variable must be set to 'engine' or 'ui' to specify which application should host domino."
end

require File.expand_path("../../../../#{app}/config/environment", __FILE__)
require 'rspec/rails'
require 'shoulda-matchers'
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    # Choose a test framework:
    with.test_framework :rspec
    with.library :rails
  end
end

if app == 'ui'
  ui_rails_engine = Pro::Application
else
  ui_rails_engine = Metasploit::Pro::UI::Engine
end

engines = [
  Metasploit::Model::Engine,
  MetasploitDataModels::Engine,
  Metasploit::Credential::Engine,
  ui_rails_engine
]

engines.each do |engine|
  support_glob = engine.root.join('spec', 'support', '**', '*.rb')

  Dir[support_glob].each { |f|
    require f
  }
end

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  # only run specs compatible with the given app
  config.filter_run_including app.to_sym

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
  
  config.deprecation_stream = Metasploit::Pro::UI::Engine.root.parent.join('test_reports','spec', 'deprecations_mm_domino.txt')

  config.use_transactional_fixtures = true

  # Setting this config option `false` removes rspec-core's monkey patching of the
  # top level methods like `describe`, `shared_examples_for` and `shared_context`
  # on `main` and `Module`. The methods are always available through the `RSpec`
  # module like `RSpec.describe` regardless of this setting.
  # For backwards compatibility this defaults to `true`.
  #
  # https://relishapp.com/rspec/rspec-core/v/3-0/docs/configuration/global-namespace-dsl
  config.expose_dsl_globally = false

  config.disable_monkey_patching!
end
