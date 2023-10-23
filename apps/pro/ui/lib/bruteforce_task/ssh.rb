module BruteforceTask::SSH
  extend ActiveSupport::Concern

  include Metasploit::Pro::AttrAccessor::Boolean

  included do
    #
    # Boolean Attributes
    #

    boolean_attr_accessor :ssh_auth_password, :default => true
    boolean_attr_accessor :ssh_auth_privkey, :default => true
    boolean_attr_accessor :ssh_auth_pubkey, :default => true
  end
end