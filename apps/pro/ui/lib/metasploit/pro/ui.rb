#
# Gems
#
# gems must load explicitly any gem declared in gemspec
# @see https://github.com/bundler/bundler/issues/2018#issuecomment-6819359
#
#

require 'active_record'
require 'acts_as_list'
require 'after_commit_queue'
require 'authlogic'
require 'carrierwave'
require 'cookiejar'
require 'delayed_job_active_record'

# if Rails.env.production?
#   class ActiveSupport::Deprecation
#     alias_method :old_warn, :warn
#     def warn(*args); end
#   end
# end

require 'formtastic'

# if Rails.env.production?
#   class ActiveSupport::Deprecation
#     alias_method :warn, :old_warn
#   end
# end


require 'has_scope'
require 'ice_cube'
require 'liquid'
require 'metasploit/concern'
require 'metasploit/credential'
require 'metasploit_data_models'
require 'network_interface'
require 'pcaprub'
require 'pg'
require 'state_machines'
require 'wicked'
Metasploit::Pro::Metamodules.require

module Metasploit
  module Pro
    # Namespace for this gem.
    module UI
      extend ActiveSupport::Autoload

      autoload :Sonar
    end
  end
end
