# @restful_api 2.0

class RestApi::V2::ServicesController < RestApi::V2::BaseController

  # @url /rest_api/v2/workspaces/:workspace_id/hosts/:host_id/services
  # @action GET
  #
  # Returns list of services for given host.
  #
  # @required [Integer] workspace_id
  # @required [Integer] host_id
  #
  # @response [Array<Mdm::Service>]
  #
  def index
    if ancestors_valid?
      @services = services_found
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  # @url /rest_api/v2/workspaces/:workspace_id/hosts/:host_id/services/:id
  # @action GET
  #
  # Returns a service by id.
  #
  # @required [Integer] workspace_id
  # @required [Integer] host_id
  # @required [Integer] id
  #
  # @response_field [Integer] id
  # @response_field [Integer] host_id
  # @response_field [Integer] port
  # @response_field [String]  state
  # @response_field [String]  name
  # @response_field [String]  info
  # @response_field [Date]    created_at
  # @response_field [Date]    updated_at
  #
  def show
    if service_valid?
      @service = service_found
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  private

  def ancestors_valid?
    workspace_found.present? && host_found.present?
  end

  def service_valid?
    ancestors_valid? && service_results.present?
  end

  def workspace_found
    ::Mdm::Workspace.where(id: params['workspace_id'])
  end

  def host_found
    ::Mdm::Host.where('id = ? AND workspace_id = ?',
                      params['host_id'],
                      params['workspace_id'])
  end

  def services_found
    ::Mdm::Service.where(host_id: params['host_id'])
  end

  def service_found
     service_results.first
  end

  def service_results
    ::Mdm::Service.where('id = ? AND host_id = ?',
                         params['id'],
                         params['host_id'])
  end
end
