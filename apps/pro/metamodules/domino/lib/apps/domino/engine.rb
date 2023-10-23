class Apps::Domino::Engine < ::Rails::Engine
  # @see http://viget.com/extend/rails-engine-testing-with-rspec-capybara-and-FactoryBot
  config.generators do |g|
    g.assets false
    g.fixture_replacement :factory_bot, dir: 'spec/factories'
    g.helper false
    g.test_framework :rspec, fixture: false
  end

  config.paths.add 'app/concerns', autoload: true
  config.paths.add 'modules'

  # Must be after any `config.paths.add` as calling config.autoload_paths will memoize all paths with autoload: true.
  config.autoload_paths += [config.root.join('lib').to_s]

  initializer 'domino.prepend_factory_path',
              # factory paths from the final Rails.application
              after: 'factory_bot.set_factory_paths',
              # before metasploit_data_models because it prepends
              before: 'metasploit_credential.prepend_factory_path' do
    if defined? FactoryBot
      relative_definition_file_path = config.generators.options[:factory_bot][:dir]
      definition_file_path = root.join(relative_definition_file_path)

      # unshift so that projects that use creds_domino can modify creds_domino* factories
      FactoryBot.definition_file_paths.unshift definition_file_path
    end
  end
end
