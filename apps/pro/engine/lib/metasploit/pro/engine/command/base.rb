#
# Gems
#

require 'active_support/core_ext/module/introspection'

#
# Project
#

require 'metasploit/pro/engine/command'
require 'metasploit/pro/engine/parsed_options'

# Based on pattern used for lib/rails/commands in the railties gem.
class Metasploit::Pro::Engine::Command::Base
  #
  # Attributes
  #

  # @!attribute [r] application
  #   The Rails application for metasploit-pro-engine.
  #
  #   @return [Metasploit::Pro::Engine::Application]
  attr_reader :application

  #
  # Class Methods
  #

  # @note {require_environment!} should be called to load `config/application.rb` to so that the RAILS_ENV can be set
  #   from the command line options in `ARGV` prior to `Rails.env` being set.
  # @note After returning, `Rails.application` will be defined and configured.
  #
  # Parses `ARGV` for command line arguments to configure the `Rails.application`.
  #
  # @return [void]
  def self.require_environment!
    parsed_options = self.parsed_options
    # RAILS_ENV must be set before requiring 'config/application.rb'
    parsed_options.environment!
    ARGV.replace(parsed_options.positional)

    # @see https://github.com/rails/rails/blob/v3.2.17/railties/lib/rails/commands.rb#L39-L40
    require Pathname.new(__FILE__).parent.parent.parent.parent.parent.parent.join('config', 'application')

    # have to configure before requiring environment because config/environment.rb calls initialize! and the initializers
    # will use the configuration from the parsed options.
    parsed_options.configure(Rails.application)
    Rails.application.require_environment!
  end

  def self.parsed_options
    parsed_options_class.new
  end

  def self.parsed_options_class
    @parsed_options_class ||= parsed_options_class_name.constantize
  end

  def self.parsed_options_class_name
    @parsed_options_class_name ||= "#{module_parent.module_parent}::ParsedOptions::#{name.demodulize}"
  end

  def self.start
    require_environment!
    new(Rails.application).start
  end

  #
  # Instance Methods
  #

  def initialize(application)
    @application = application
  end

  # @abstract Use {#application} to start this command.
  #
  # Starts this command.
  #
  # @return [void]
  # @raise [NotImplementedError]
  def start
    raise NotImplementedError
  end
end
