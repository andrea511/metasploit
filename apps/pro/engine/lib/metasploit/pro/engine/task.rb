# have to be exact so minimum is loaded prior to parsing arguments which could influence loading.
require 'active_support/dependencies/autoload'

module Metasploit::Pro::Engine::Task
  # Namespace for things related to management of Tasks.
  # NOTE: this isn't comprehensive until legacy things are moved into this namepsace
  extend ActiveSupport::Autoload

  autoload :PauseResume
end
