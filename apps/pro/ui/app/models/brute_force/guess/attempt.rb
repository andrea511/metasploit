# A proposed or accomplished attempt to use {#brute_force_guess_core} to login into {#service} as part of a
# {#brute_force_run}.  {#attempted_at} is `nil` if this attempt has not been made.  {#attempted_at} is the date and time
# of the attempt if it was made.
class BruteForce::Guess::Attempt < ApplicationRecord

  #
  # Associations
  #

  # @!attribute brute_force_run
  #   The run of which this attempt is a part.
  #
  #   @return [BruteForce::Run]
  belongs_to :brute_force_run,
             class_name: 'BruteForce::Run',
             inverse_of: :brute_force_guess_attempts

  # @!attribute brute_force_guess_core
  #   The core credential being used to log into {#service}.
  #
  #   @return [BruteForce::Guess::Core]
  belongs_to :brute_force_guess_core,
             class_name: 'BruteForce::Guess::Core',
             inverse_of: :brute_force_guess_attempts

  # @!attribute service
  #   The service that is being logged into.
  #
  #   @return [Mdm::Service]
  belongs_to :service,
             class_name: 'Mdm::Service',
             inverse_of: :brute_force_guess_attempts

  belongs_to :session,
             optional: true,
             class_name: 'Mdm::Session'

  belongs_to :login,
             optional: true,
             class_name: 'Metasploit::Credential::Login'

  #
  # Attributes
  #

  # @!attribute attempted_at
  #   When this attempt was made.
  #
  #   @return [DateTime] if the attempt was already made
  #   @return [nil] if the attempt has not been made yet

  # @!attribute created_at
  #   When this attempt was created.
  #
  #   @return [DateTime]

  # @!attribute updated_at
  #   The last time this attempt was updated.
  #
  #   @return [DateTime]

  #
  #
  # Validations
  #
  #

  #
  # Method Validations
  #

  validate :consistent_workspaces

  #
  # Attribute Validations
  #

  validates :brute_force_run,
            presence: true
  validates :brute_force_guess_core,
            presence: true
  validates :service,
            presence: true
  validates :service_id,
            uniqueness: {
              scope: [
                       :brute_force_run_id,
                       :brute_force_guess_core_id
                     ]
            }
  validates :status,
            inclusion: { in: BruteForce::AttemptStatus::ALL_STATUSES }

  #
  # Instance Methods
  #

  # This method returns a {Metasploit::Framework::Credential} by calling
  # {BruteForce::Guess::Core#to_credential} on the associated
  # {Metasploit::Credential::Core}.
  #
  # @return {Metasploit::Framework::Credential}
  def to_credential
    credential = self.brute_force_guess_core.to_credential
    credential.parent = self
    credential
  end

  private

  # Validates that `BruteForce::Guess::Core#workspace` of {#brute_force_guess_core} matches
  # `Mdm::Host#workspace` of `Mdm::Service#host` of {#service}.
  def consistent_workspaces
    unless brute_force_guess_core.try(:workspace) == service.try(:host).try(:workspace)
      errors.add(:base, :inconsistent_workspaces)
    end
  end


end
