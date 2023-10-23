module BruteforceTask::Credentials::Mutation
  extend ActiveSupport::Concern

  include Metasploit::Pro::AttrAccessor::Boolean

  included do
    boolean_attr_accessor :mutate_imported, :default => false
    boolean_attr_accessor :mutate_known, :default => false
    boolean_attr_accessor :mutate_quick, :default => false
    boolean_attr_accessor :mutation_opt_append_single_digit, :default => false
    boolean_attr_accessor :mutation_opt_append_single_punc, :default => false
    boolean_attr_accessor :mutation_opt_l33t_passwords, :default => false
    boolean_attr_accessor :mutation_opt_prepend_single_digit, :default => false
    boolean_attr_accessor :mutation_opt_prepend_single_punc, :default => false
    boolean_attr_accessor :mutation_opt_substitute_single_digits, :default => false
  end
end