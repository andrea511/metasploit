#
# Gems
#

# have to be exact so minimum is loaded prior to parsing arguments which could influence loading.
require 'active_support/dependencies/autoload'


# @note Must use the nested declaration of the {Metasploit::Pro::Engine::Comamnd} namespace because commands need to be
# able to be required directly without any other part of pro/engine besides config/boot so that the commands can parse
# arguments, setup RAILS_ENV, and load config/application.rb correctly.
module Metasploit
  module Pro
    module Engine
      module Command
        # Namespace for commands for metasploit-pro-engine.  There are corresponding classes in the
        # {Metasploit::Pro::Engine::ParsedOptions} namespace, which handle for parsing the options for each command.
        extend ActiveSupport::Autoload

        autoload :Base
        autoload :Console
        autoload :Service
      end
    end
  end
end
