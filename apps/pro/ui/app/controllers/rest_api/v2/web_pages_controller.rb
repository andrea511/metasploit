# @restful_api 2.0

class RestApi::V2::WebPagesController < RestApi::V2::BaseController

  # @url /rest_api/v2/workspaces/:workspace_id/hosts/:host_id/services/:service_id/web_sites/:web_site_id/web_pages
  # @action GET
  #
  # Returns list of web pages for given web site.
  #
  # @required [Integer] workspace_id
  # @required [Integer] host_id
  # @required [Integer] service_id
  # @required [Integer] web_site_id
  #
  # @response [Array<Mdm::WebPage>]
  #
  def index
    if ancestors_valid?
      @web_pages = web_pages_found
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  # @url /rest_api/v2/workspaces/:workspace_id/hosts/:host_id/services/:service_id/web_sites/:web_site_id/web_pages/:id
  # @action GET
  #
  # Returns a web page by id.
  #
  # @required [Integer] workspace_id
  # @required [Integer] host_id
  # @required [Integer] service_id
  # @required [Integer] web_site_id
  # @required [Integer] id
  #
  # @response_field [Integer]       id
  # @response_field [Integer]       web_site_id
  # @response_field [String]        path
  # @response_field [String]        query
  # @response_field [Integer]       code
  # @response_field [String]        cookie
  # @response_field [String]        auth
  # @response_field [String]        ctype
  # @response_field [Date]          mtime
  # @response_field [String]        location
  # @response_field [Array<String>] headers
  # @response_field [String]        body
  # @response_field [String]        request
  # @response_field [Date]          created_at
  # @response_field [Date]          updated_at
  #
  def show
    if web_page_valid?
      @web_page = web_page_found
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  private

  def ancestors_valid?
    workspace_found.present? &&
    host_found.present?      &&
    service_found.present?   &&
    web_site_found.present?
  end

  def web_page_valid?
    ancestors_valid? && web_page_results.present?
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

  def web_site_found
    ::Mdm::WebSite.where('id = ? AND service_id = ?',
                         params['web_site_id'],
                         params['service_id'])
  end

  def web_pages_found
    ::Mdm::WebPage.where(web_site_id: params['web_site_id'])
  end

  def web_page_found
    web_page_results.first
  end

  def web_page_results
    ::Mdm::WebPage.where('id = ? AND web_site_id = ?',
                         params['id'],
                         params['web_site_id'])
  end

end
