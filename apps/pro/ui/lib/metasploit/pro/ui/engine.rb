require 'metasploit/pro/ui/common_configuration'

module Metasploit
  module Pro
    module UI
      # The `Rails::Engine` used to load `ui`'s models and run `ui`'s shared initializers (from `ui/config/initializer`)
      # in `engine/prosvc.rb`.
      class Engine < Rails::Engine
        include Metasploit::Pro::UI::CommonConfiguration

        # @see http://viget.com/extend/rails-engine-testing-with-rspec-capybara-and-FactoryBot
        config.generators do |g|
          g.fixture_replacement :factory_bot, dir: 'spec/factories'
        end

        initializer 'metasploit_pro_ui.prepend_factory_path',
                    # factory paths from the final Rails.application
                    after: 'factory_bot.set_factory_paths',
                    # before metasploit_credential because it prepends
                    before: 'metasploit_credential.prepend_factory_path' do
          if defined? FactoryBot
            relative_definition_file_path = config.generators.options[:factory_bot][:dir]
            definition_file_path = root.join(relative_definition_file_path)

            # unshift so that projects that use metasploit-pro-ui can modify metasploit_pro_ui_* factories
            FactoryBot.definition_file_paths.unshift definition_file_path
          end
        end
      end
    end
  end
end
