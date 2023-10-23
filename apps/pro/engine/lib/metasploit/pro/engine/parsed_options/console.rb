# Parsed options for {Metasploit::Pro::Engine::Command::Console}
class Metasploit::Pro::Engine::ParsedOptions::Console < Metasploit::Pro::Engine::ParsedOptions::Base
  def option_parser
    unless @option_parser
      super.tap { |option_parser|
        option_parser.banner = "Usage: #{option_parser.program_name} [options] [-- [msfconsole_options]]\n" \
                             "  To see msfconsole options run #{option_parser.program_name} -- --help"

        option_parser.separator ''
        option_parser.separator 'Console options:'

        option_parser.on(
            '-r',        
            '--remote',
            '--rpc',
            'Connect to RPC interface of already running prosvc instead of starting a new (local) console process. This option requires "-T" (authentication token) option as well.') do
          options.console.mode = :remote
        end

        option_parser.on_tail() do
          unless options.environment == 'development'
            unless (options.console.mode == :remote && options.token) || (options.token.nil? && options.console.mode != :remote)
              e = OptionParser::ParseError.new("'-r/--remote/--rpc' requires '-T/--token' (authentication token) option as well.")
              e.reason = 'The following options failed to parse'
              raise e
            end
          end
        end
      }
    end

    @option_parser
  end
end