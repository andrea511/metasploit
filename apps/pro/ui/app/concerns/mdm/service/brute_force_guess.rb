# Adds associations to `Mdm::Service` which are inverses of association on models under
# {BruteForce::Guess}.
module Mdm::Service::BruteForceGuess
  extend ActiveSupport::Concern

  included do
    #
    # Associations
    #

    # @!attribute brute_force_reuse_attempts
    #   Attempts to reuse `Metasploit::Credential::Core` from other services against this service.
    #
    #   @return [ActiveRecord::Relation<BruteForce::Reuse::Attempt>]
    has_many :brute_force_guess_attempts,
             class_name: 'BruteForce::Guess::Attempt',
             dependent: :destroy,
             inverse_of: :service



  end
end
