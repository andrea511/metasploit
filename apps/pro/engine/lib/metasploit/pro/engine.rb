#
# Core
#

root = Pathname.new(__FILE__).expand_path.parent.parent.parent.parent

# Load the feature flag files
require root.parent.join('ui', 'config', 'feature_flags')

#
# Gems
#
# gems must load explicitly any gem declared in gemspec
# @see https://github.com/bundler/bundler/issues/2018#issuecomment-6819359
#
#

# must be before gems, such as metasploit/concern, which conditionally define their Rails::Engine based on Rails being
# defined.
require 'rails'
require 'sonar'
require 'metasploit/concern'
require 'metasploit/framework'
require 'metasploit/pro/ui'

Metasploit::Pro::Metamodules.require
module Metasploit::Pro::Metamodules
  extend ActiveSupport::Autoload

  autoload :RunStats
end

#
# Project
#

require 'pro/filters'

module Metasploit::Pro::Engine
  extend ActiveSupport::Autoload

  autoload :Command
  autoload :Configuration
  autoload :Credential
  autoload :Database
  autoload :LogSubscriber
  autoload :ModuleUIProgressBarOutput
  autoload :Notifications
  autoload :ParsedOptions
  autoload :Sonar
  autoload :Task
end
