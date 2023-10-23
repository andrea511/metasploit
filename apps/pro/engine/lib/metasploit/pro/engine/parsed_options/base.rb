#
# Standard Library
#

require 'optparse'

#
# Gems
#

require 'active_support/ordered_options'

#
# Project
#

require 'metasploit/pro/engine/configuration'
require 'metasploit/pro/engine/parsed_options'

# Options parsed from the command line for prosvc that can be used to change the
# `Metasploit::Pro::Engine::Application.config` and `Rails.env`
class Metasploit::Pro::Engine::ParsedOptions::Base
  #
  # CONSTANTS
  #

  # prosvc boots in production mode instead of the normal rails default of development.
  DEFAULT_ENVIRONMENT = 'production'

  #
  # Attributes
  #

  attr_reader :positional

  #
  # Instance Methods
  #

  def initialize(arguments=ARGV)
    @positional = option_parser.parse(arguments)
  end

  # Copies {#options} to the `application`'s config'
  #
  # @param application [Rails::Application]
  # @return [void]
  def configure(application)
    copy from: options, to: application.config
  end

  # Sets the `RAILS_ENV` environment variable.
  #
  # 1. If the -E/--environment option is given, then its value is used.
  # 2. The default value, 'production', is used.
  #
  # @return [void]
  def environment!
    if defined?(Rails) && Rails.instance_variable_defined?(:@_env)
      raise "#{self.class}##{__method__} called too late to set RAILS_ENV: Rails.env already memoized"
    end

    ENV['RAILS_ENV'] = options.environment
  end

  private

  def copy(options={})
    options.assert_valid_keys(:from, :to)

    from = options.fetch(:from)
    to = options.fetch(:to)

    from.each do |key, value|
      if value.is_a? Hash
        copy from: value,
             to: to.send(key)
      else
        to.send("#{key}=", value)
      end
    end
  end

  # Options parsed from
  #
  # @return [ActiveSupport::OrderedOptions]
  def options
    unless @options
      options = ActiveSupport::OrderedOptions.new
      # If RAILS_ENV is set, then it will be used, but if RAILS_ENV is set and the --environment option is given, then
      # --environment value will be used to reset ENV[RAILS_ENV].
      options.environment = ENV['RAILS_ENV'] || DEFAULT_ENVIRONMENT

      Metasploit::Pro::Engine::Configuration.defaults!(options)

      @options = options
    end

    @options
  end

  # Parses arguments into {#options}.
  #
  # @return [OptionParser]
  def option_parser
    @option_parser ||= OptionParser.new { |option_parser|

      option_parser.separator ''
      option_parser.separator 'Authentication options:'

      option_parser.on(
          '-T',
          '--token STRING',
          'Token key to access MSF RPC Service.',
          'Needs to match for both the server and remote console'
      ) do |token|
        options.token = token
      end

      option_parser.separator ''
      option_parser.separator 'Rails options'

      option_parser.on(
          '-E',
          '--environment ENVIRONMENT',
          %w{development production test},
          "The Rails environment. Will use RAIL_ENV environment variable if that is set.  " \
          "Defaults to production if neither option not RAILS_ENV environment variable is set."
      ) do |environment|
        options.environment = environment
      end

      #
      # Tail
      #

      option_parser.separator ''
      option_parser.on_tail('-h', '--help', 'Show this message') do
        puts option_parser
        exit
      end
    }
  end
end