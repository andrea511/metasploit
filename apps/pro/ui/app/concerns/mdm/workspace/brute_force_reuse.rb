# Adds associations to `Mdm::Workspace` which are inverses of association on models under {BruteForce::Reuse}.
module Mdm::Workspace::BruteForceReuse
  extend ActiveSupport::Concern

  included do
    #
    # Associations
    #

    # @!attribute brute_force_reuse_group
    #   Groups of `BruteForce::ReUse::Core`s that are scoped to this workspace.
    #
    #   @return [ActiveRecord::Relation<BruteForce::Reuse::Group>]
    has_many :brute_force_reuse_groups,
             class_name: 'BruteForce::Reuse::Group',
             dependent: :destroy,
             inverse_of: :workspace
  end
end