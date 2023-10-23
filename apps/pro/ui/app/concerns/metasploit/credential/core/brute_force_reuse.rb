# Adds associations to `Metasploit::Credential::Core` which are inverses of association on models under
# {BruteForce::Reuse}.
module Metasploit::Credential::Core::BruteForceReuse
  extend ActiveSupport::Concern

  included do
    #
    # Associations
    #

    # @!attribute brute_force_reuse_attempts
    #   Attempts to use this core credential against different `Mdm::Service` than the one from which it was originally
    #   gathered.
    #
    #   @return [ActiveRecord::Relation<BruteForce::Reuse::Attempt>]
    has_many :brute_force_reuse_attempts,
             class_name: 'BruteForce::Reuse::Attempt',
             dependent: :destroy,
             foreign_key: :metasploit_credential_core_id,
             inverse_of: :metasploit_credential_core

    # @!attribute brute_force_reuse_groups
    #   Reuse groups to which this core credential belongs.
    #
    #   @return [ActiveRecord::Relation<BruteForce::Reuse::Group>]
    has_and_belongs_to_many :brute_force_reuse_groups,
                            association_foreign_key: :brute_force_reuse_group_id,
                            class_name: 'BruteForce::Reuse::Group',
                            foreign_key: :metasploit_credential_core_id,
                            join_table: :brute_force_reuse_groups_metasploit_credential_cores

    #
    # Callbacks
    #

    after_destroy :destroy_empty_brute_force_reuse_groups

    #
    # Validations
    #

    validate :consistent_workspaces

    #
    # Scopes
    #
    scope :group_id, lambda { |group_id|
      joins(:brute_force_reuse_groups).where(BruteForce::Reuse::Group.arel_table[:id].eq(group_id))
    }

    #
    # Instance Methods
    #

    private

    # Validates that {#workspace} matches the {BruteForce::Reuse::Group#workspaces} for all {#brute_force_reuse_groups}.
    #
    # @return [void]
    def consistent_workspaces
      brute_force_reuse_groups.each do |brute_force_reuse_group|
        unless brute_force_reuse_group.workspace == workspace
          # Trying to guarantee that we don't add duplicate errors
          if errors[:workspace].count(I18n.translate!('activerecord.errors.models.metasploit/credential/core.attributes.workspace.inconsistent')) < 1
            errors.add(:workspace, :inconsistent)
          end

          # only report the error once even if there are multiple workspaces across the brute_force_reuse_groups as
          # there isn't a good way to highlight which one has the error.
          break
        end
      end
    end

    # Destroys {#brute_force_reuse_groups} that have no {BruteForce::Reuse::Group#metasploit_credential_cores}.
    #
    # @return [void]
    def destroy_empty_brute_force_reuse_groups
      BruteForce::Reuse::Group.empty.readonly(false).destroy_all
    end
  end
end