# @restful_api 2.0

class RestApi::V2::WebSitesController < RestApi::V2::BaseController

  # @url /rest_api/v2/workspaces/:workspace_id/hosts/:host_id/services/:service_id/web_sites
  # @action GET
  #
  # Returns list of web site for given service.
  #
  # @required [Integer] workspace_id
  # @required [Integer] host_id
  # @required [Integer] service_id
  #
  # @response [Array<Mdm::WebSite>]
  #
  def index
    if ancestors_valid?
      @web_sites = web_sites_found
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  # @url /rest_api/v2/workspaces/:workspace_id/hosts/:host_id/services/:service_id/web_sites/:id
  # @action GET
  #
  # Returns a web site by id.
  #
  # @required [Integer] workspace_id
  # @required [Integer] host_id
  # @required [Integer] service_id
  # @required [Integer] id
  #
  # @response_field [Integer] id
  # @response_field [Integer] service_id
  # @response_field [String]  vhost
  # @response_field [String]  comments
  # @response_field [Hash]    options
  # @response_field [Date]    created_at
  # @response_field [Date]    updated_at
  #
  def show
    if web_site_valid?
      @web_site = web_site_found
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  private

  def ancestors_valid?
    workspace_found.present? &&
    host_found.present?      &&
    service_found.present?
  end

  def web_site_valid?
    ancestors_valid? && web_site_results.present?
  end

  def workspace_found
    ::Mdm::Workspace.where(id: params['workspace_id'])
  end

  def host_found
    ::Mdm::Host.where('id = ? AND workspace_id = ?',
                      params['host_id'],
                      params['workspace_id'])
  end

  def service_found
    ::Mdm::Service.where('id = ? AND host_id = ?',
                         params['service_id'],
                         params['host_id'])
  end

  def web_sites_found
    ::Mdm::WebSite.where(service_id: params['service_id'])
  end

  def web_site_found
    web_site_results.first
  end

  def web_site_results
    ::Mdm::WebSite.where('id = ? AND service_id = ?',
                         params['id'],
                         params['service_id'])
  end

end
