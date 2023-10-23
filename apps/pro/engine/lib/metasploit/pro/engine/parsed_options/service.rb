require 'metasploit/pro/engine/configuration'
require 'metasploit/pro/engine/parsed_options'
require 'metasploit/pro/engine/parsed_options/base'

# Parsed options for {Metasploit::Pro::Engine::Command::Service}
class Metasploit::Pro::Engine::ParsedOptions::Service < Metasploit::Pro::Engine::ParsedOptions::Base
  def option_parser
    unless @option_parser
      super.tap { |option_parser|
        option_parser.separator ''
        option_parser.separator 'Console options:'

        option_parser.on('-c', '--console', 'Start a console session after starting the MSF RPC Service') do
          options.console.run = true
        end

        option_parser.separator ''
        option_parser.separator 'Server options'

        option_parser.on(
            '-a',
            '--address ADDRESS',
            'IP Address to which Msf::RPC::Service should bind'
        ) do |address|
          options.server.host = address
        end

        option_parser.on '-p',
                         '--port PORT',
                         Integer,
                         "Bind to this port instead of #{Metasploit::Pro::Engine::Configuration::DEFAULT_SERVER_PORT}" do |port|
          options.server.port = port
        end

        option_parser.on('-S', '--no-ssl', 'Disable SSL on for the Msf RPC Service') do
          options.ssl = false
        end

        option_parser.on('-u', '--uri URI', 'URI for the Msf RPC Service') do |uri|
          options.uri = uri
        end
      }
    end

    @option_parser
  end
end