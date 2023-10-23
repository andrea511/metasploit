module Mdm::Loot::Scopes
  extend ActiveSupport::Concern

  included do
    # Finds loots that are attached to a given workspace
    #
    # @method workspace_id(id)
    # @scope Mdm::Loot
    # @param id [Integer] the workspace to look in
    # @return [ActiveRecord::Relation] scoped to the workspace
    scope :workspace_id, ->(id) {
      where('workspace_id' => id)
    }
  end
end