require 'metasploit/framework/login_scanner'

# Collects together `BruteForce::Guess::Attempt`s and `BruteForce::ReUse::Attempt`s so the progress of trying attempts
# can be tracked and attempts on the same `Mdm::Service` can be removed from the run when only one login per
# `Mdm::Service` is desired.
class BruteForce::Run < ApplicationRecord

  #
  # Constants
  #
  BRUTEFORCEABLE_SERVICES = [
    'AFP',
    'DB2',
    'FTP',
    'HTTP',
    'HTTPS',
    'MSSQL',
    'MySQL',
    'POP3',
    'Postgres',
    'SMB',
    'SNMP',
    'SSH',
    'SSH_PUBKEY',
    'Telnet',
    'VNC',
    'WinRM'
  ]

  #
  # Associations
  #

  # @!attribute brute_force_reuse_attempts
  #   Attempts to reuse `Metasploit::Credential::Core` against different `Mdm::Service` from which they were originally
  #   gathered.
  #
  #   @return [ActiveRecord::Relation<BruteForce::Reuse::Attempt>]
  has_many :brute_force_reuse_attempts,
           class_name: 'BruteForce::Reuse::Attempt',
           dependent: :destroy,
           foreign_key: :brute_force_run_id,
           inverse_of: :brute_force_run

  # @!attribute brute_force_guess_attempts
  #   Attempts to reuse `BruteForce::Guess::Core` against different `Mdm::Service` from which they were originally
  #   gathered.
  #
  #   @return [ActiveRecord::Relation<BruteForce::Guess::Attempt>]
  has_many :brute_force_guess_attempts,
           class_name: 'BruteForce::Guess::Attempt',
           dependent: :destroy,
           foreign_key: :brute_force_run_id,
           inverse_of: :brute_force_run

  # @!attribute metasploit_credential_cores
  #   Returns all the `Metasploit::Credential::Core` objects that are used in this run.
  #
  #   @return [ActiveRecord::Relation<Metasploit::Credential::Core>]
  has_many :metasploit_credential_cores,
           -> { uniq(true) },
           class_name: 'Metasploit::Credential::Core',
           through: :brute_force_reuse_attempts

  # @!attribute task
  #   The associated Task that this run is operating in.
  #
  #   @return [Mdm::Task]
  belongs_to :task,
             class_name: 'Mdm::Task',
             optional: true, # initially not required and set during execution
             dependent: :destroy

  #
  # Attributes
  #

  # @!attribute config
  #   The config for this brute force run.
  #
  #   @return [Hash]
  serialize :config, JSON

  #
  # Validations
  #

  validates :config, presence: true

  #
  # Hooks
  #

  # Creates BruteForce::Reuse::Attempt objects for the given +core_ids+ and +service_id+
  # @param [Array<Integer>] the ids of the `Metasploit::Credential::Core` objects that
  #   represent the credentials we want to use in this run
  # @param [Array<Integer>] the ids of the `Mdm::Services` that we want to try to authenticate
  #   with in this run.
  def create_attempts(core_ids, service_ids)
    cores = Metasploit::Credential::Core.where(id: core_ids)
    services = Mdm::Service.where(id: service_ids)

    # attempts will end up being an array of hashes for creating the db models
    attempts = []

    # iterate through every combination of cores and services
    cores.to_a.product(services).each do |core, service = pair|
      # get all the LoginScanner::* classes that can be used on this Service
      scanners = Metasploit::Framework::LoginScanner.classes_for_service(service)

      # query the KennyLogginsCanner::* classes to see if the Core is supported
      is_usable_core = scanners.any? do |scanner_klass|
        scanner_klass::PRIVATE_TYPES.any? do |type|
          core.private and type.to_s == core.private.type.split('::').last.underscore
        end
      end

      if is_usable_core
        attempt = BruteForce::Reuse::Attempt.new
        attempt.service_id = service.id
        attempt.brute_force_run_id = self.id
        attempt.metasploit_credential_core_id = core.id
        attempts << attempt
      end
    end

    # save our attempts to the db
    ApplicationRecord.transaction { attempts.each(&:save) }
  end
end
