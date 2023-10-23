# Shared initializers

Only initializers that should be loaded by both Pro::Application for the rails UI and by Metasploit::Pro::UI::Engine
as part of prosvc should be declared as files in this directory.

# Unshared initializers

Use the [list of initializers and their order in Rails 3.2.17](http://guides.rubyonrails.org/v3.2.17/configuring.html#initializers)
to determine what to pass to `:after` and/or `:before` to ensure your initializer runs in the correct order.

## Initializers just for Rail UI

If an initializer is only for Rails UI and not for prosvc, then declare the initializer in `ui/config/application.rb`
using the `initializer` block syntax:

    module Pro
      class Applicaiton < Rails::Application
        initializer 'metasploit-pro-ui.<name>', after: <initializer>, before: <initializer> do
          # ...
        end
      end
    end

## Initializers just for ui components when used in prosvc

If an initializer is only there to support prosvc when using `ui`'s code, then declare the initializer in
`ui/lib/metasploit/pro/ui/engine.rb` using the `initializer` block syntax:

    module Metasploit
      module Pro
        module UI
          class Engine < Rails::Engine
            initializer 'metasploit-pro-ui.<name>', after: <initializer>, before: <initializer> do
              # ...
            end
          end
        end
      end
    end
