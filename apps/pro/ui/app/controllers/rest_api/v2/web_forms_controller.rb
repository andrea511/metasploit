# @restful_api 2.0

class RestApi::V2::WebFormsController < RestApi::V2::BaseController

  # @url /rest_api/v2/workspaces/:workspace_id/hosts/:host_id/services/:service_id/web_sites/:web_site_id/web_forms
  # @action GET
  #
  # Returns list of web forms for given web site.
  #
  # @required [Integer] workspace_id
  # @required [Integer] host_id
  # @required [Integer] service_id
  # @required [Integer] web_site_id
  #
  # @response [Array<Mdm::WebForm>]
  #
  def index
    if ancestors_valid?
      @web_forms = web_forms_found
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  # @url /rest_api/v2/workspaces/:workspace_id/hosts/:host_id/services/:service_id/web_sites/:web_site_id/web_forms/:id
  # @action GET
  #
  # Returns a web form by id.
  #
  # @required [Integer] workspace_id
  # @required [Integer] host_id
  # @required [Integer] service_id
  # @required [Integer] web_site_id
  # @required [Integer] id
  #
  # @response_field [Integer] id
  # @response_field [Integer] web_site_id
  # @response_field [String]  path
  # @response_field [String]  method
  # @response_field [Hash]    params
  # @response_field [String]  query
  # @response_field [Date]    created_at
  # @response_field [Date]    updated_at
  #
  def show
    if web_form_valid?
      @web_form = web_form_found
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

  def web_form_valid?
    ancestors_valid? && web_form_results.present?
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

  def web_forms_found
    ::Mdm::WebForm.where(web_site_id: params['web_site_id'])
  end

  def web_form_found
    web_form_results.first
  end

  def web_form_results
    ::Mdm::WebForm.where('id = ? AND web_site_id = ?',
                         params['id'],
                         params['web_site_id'])
  end

end
