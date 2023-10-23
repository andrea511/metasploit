module BruteforceTask::Limits
  extend ActiveSupport::Concern

  include Metasploit::Pro::AttrAccessor

  included do
    #
    # Boolean Attributes
    #

    boolean_attr_accessor :brute_sessions, :default => true
    boolean_attr_accessor :stop_on_success, :default => false

    #
    # Integer Attributes
    #

    integer_attr_accessor :max_guesses_overall
    integer_attr_accessor :max_guesses_per_service
    integer_attr_accessor :max_guesses_per_user
    integer_attr_accessor :max_minutes_overall
    integer_attr_accessor :max_minutes_per_service
  end
end