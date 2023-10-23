module BruteforceTask::Credentials::Generation
  extend ActiveSupport::Concern

  include Metasploit::Pro::AttrAccessor::Boolean

  included do
    boolean_attr_accessor :mssql_windows_auth, :default => false
    boolean_attr_accessor :preserve_domains, :default => true
    boolean_attr_accessor :recombine_creds, :default => true
    boolean_attr_accessor :skip_blank_passwords, :default => false
    boolean_attr_accessor :skip_builtin_unix_accounts, :default => false
    boolean_attr_accessor :skip_builtin_windows_accounts, :default => false
    boolean_attr_accessor :skip_machine_names, :default => false
  end
end