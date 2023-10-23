#
# Gems
#

require 'readline'
require 'active_support/core_ext/module/delegation'

#
# Project
#

require 'metasploit/pro/engine/command'
require 'metasploit/pro/engine/command/base'
require 'metasploit/framework/command/console'

# Based on pattern used for lib/rails/commands in the railties gem.
class Metasploit::Pro::Engine::Command::Console < Metasploit::Pro::Engine::Command::Base
  # Starts console in either local or rpc mode.
  def start
    send("start_#{config.console.mode}")
  end

  private

  delegate :config,
           to: :application

  # Starts a local console NOT connected to already running prosvc, but with
  # the access to the Pro modules, plugins and database.
  def start_local
    puts "[*] Starting Metasploit Console..."

    # Inject the Pro plugin into the command-line for msfconsole

    ARGV.unshift(Rails.root.parent.join('plugins', 'pro').to_path)
    ARGV.unshift("-p")

    # Load the Metasploit Console
    Metasploit::Framework::Command::Console.start

    exit(0)
  end

  # Starts remote console connected to RPC interface of already running prosvc.
  #
  # @return [void]
  def start_remote
    # Process additional arguments
    opts  = {}
    token = ARGV.shift
    if token
      opts['Token'] = token
    end

    @pro = Pro::Client.new(opts)

    @prompt = 'msfpro> '
    @busy   = 'nope'
    @wrote  = false

    r = @pro.call("console.create")
    @cid = r['id']


    ::Readline.basic_word_break_characters = "\x00"
    ::Readline.completion_proc = Proc.new do |line|
      r = @pro.call("console.tabs", @cid, line)
      r['tabs'] ? r['tabs'] : nil
    end

    Thread.new do
      begin
        while(true)
          r = @pro.call("console.read", @cid)
          if r['data']
            @busy   = r['busy']
            old_prompt = @prompt
            @prompt = r['prompt']

            @wrote = true if (old_prompt != @prompt)

            if ! r['data'].empty?
              $stdout.write r['data']
              @wrote = true
            end

            delay = 0.5
            delay = 0.10 if @busy
            select(nil, nil, nil, delay)
          end
        end
      rescue ::Exception => e
        $stderr.puts "Error: #{e.class} #{e}\n #{e.backtrace.join "\n"}"
        Process.kill(9, $$)
      end
    end

    select(nil, nil, nil, 0.5)

    while(line = Readline.readline(@prompt))
      begin
        @wrote = false
        @pro.call("console.write", @cid, line + "\n")
      rescue ::Interrupt
        raise $!
      rescue ::SystemExit
        raise $!
      rescue ::Msf::RPC::ServerException => e
        puts "error: #{e.error_class} #{e.error_message} #{e.error_backtrace}"
      rescue ::Exception => e
        puts "error: #{e}\n #{e.backtrace.join"\n"}"
      end

      begin
        while ! @wrote
          ::IO.select(nil, nil, nil, 0.25)
        end
      rescue ::Interrupt
        puts "Interrupt"
      end

    end
  end
end
