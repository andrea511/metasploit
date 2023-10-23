# @restful_api 2.0

class RestApi::V2::WorkspacesController < RestApi::V2::BaseController
  
  # @url /rest_api/v2/workspaces
  # @action GET
  #
  # Returns list of workspaces.
  # Assumes the user wants ALL Workspaces across all Users
  #
  # @response [Array<Mdm::Workspace>]
  #
  def index
    @workspaces = workspaces_found
  end

  # @url /rest_api/v2/workspaces/:id
  # @action GET
  #
  # Returns a workspace by id
  #
  # @required [Integer] id
  #
  # @response_field [Integer] id
  # @response_field [String]  name
  # @response_field [String]  boundary
  # @response_field [String]  description
  # @response_field [Integer] owner_id
  # @response_field [Integer] limit_to_network
  # @response_field [Date]    created_at
  # @response_field [Date]    updated_at
  #
  def show
    if workspace_valid?
      @workspace = workspace_found
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  private

  def workspaces_found
    ::Mdm::Workspace.all
  end

  def workspace_found
    ::Mdm::Workspace.where(id: params['id']).first
  end

  def workspace_valid?
    workspace_found.present?
  end
end
