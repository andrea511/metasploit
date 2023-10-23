module Mdm::Service::Scopes
  extend ActiveSupport::Concern

  included do
    # Finds services that are attached to a given workspace
    #
    # @method workspace_id(id)
    # @scope Mdm::Service
    # @param id [Integer] the workspace to look in
    # @return [ActiveRecord::Relation] scoped to the workspace
    scope :workspace_id, ->(id) {
      joins(:host).where('hosts.workspace_id' => id)
    }
  end
end