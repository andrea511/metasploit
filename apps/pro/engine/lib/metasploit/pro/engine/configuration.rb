# @note Must use the nested declaration of the {Metasploit::Pro::Engine::Configuration} namespace because commands need
# to be to use {Metasploit::Pro::Engine::Configuration} without requiring `'metasploit/pro/engine'`, which would trigger
# `Rails.env` to be memoized, which would defeat the purpose of using the {defaults!} in parsing options.
module Metasploit
  module Pro
    module Engine
      module Configuration
        #
        # CONSTANTS
        #

        # Default host for the server and flash policy server.
        DEFAULT_HOST = '127.0.0.1'
        # Default port for the server.
        DEFAULT_SERVER_PORT = 50505
        # Default URI for the XMLRPC.
        DEFAULT_URI = '/api'

        # Adds default configuration options for {Metasploit::Pro::UI::Application} to `configuration`.
        #
        # @param configuration [#method_missing]
        # @return [void]
        def self.defaults!(configuration)
          configuration.console = ActiveSupport::OrderedOptions.new
          configuration.console.run = false
          configuration.console.mode = :local

          server = ActiveSupport::OrderedOptions.new
          server.host = DEFAULT_HOST
          server.port = DEFAULT_SERVER_PORT
          configuration.server = server

          configuration.ssl = false
          configuration.token = nil
          configuration.uri = DEFAULT_URI
        end
      end
    end
  end
end