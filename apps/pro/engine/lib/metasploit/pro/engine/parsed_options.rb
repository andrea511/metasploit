#
# Gems
#

require 'active_support/dependencies/autoload'

# # @note Must use the nested declaration of the {Metasploit::Pro::Engine::ParsedOptions} namespace because commands,
# which use parsed options, need to be able to be required directly without any other part of pro/engine besides
# config/boot so that the commands can parse arguments, setup RAILS_ENV, and load config/application.rb correctly.
module Metasploit
  module Pro
    module Engine
      # Namespace for parsed options for {Metasploit::Pro::Engine::Command commands}.  The names of `Class`es in this
      # namespace correspond to the name of the `Class` in the {Metasploit::Pro::Engine::Command} namespace for which
      # this namespace's `Class` parses options.
      module ParsedOptions
        extend ActiveSupport::Autoload

        autoload :Base
        autoload :Console
        autoload :Service
      end
    end
  end
end

