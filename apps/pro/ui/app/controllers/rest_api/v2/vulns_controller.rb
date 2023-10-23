# @restful_api 2.0

class RestApi::V2::VulnsController < RestApi::V2::BaseController

  # @url /rest_api/v2/workspaces/:workspace_id/hosts/:host_id/services/:service_id/vulns
  # @action GET
  #
  # Returns list of vulns for given service.
  #
  # @required [Integer] workspace_id
  # @required [Integer] host_id
  # @required [Integer] service_id
  #
  # @response [Array<Mdm::Vuln>]
  #
  def index
    if ancestors_valid?
      @vulns = vulns_found
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  # @url /rest_api/v2/workspaces/:workspace_id/hosts/:host_id/services/:service_id/vulns/:id
  # @action GET
  #
  # Returns a vuln by id.
  #
  # @required [Integer] workspace_id
  # @required [Integer] host_id
  # @required [Integer] service_id
  # @required [Integer] id
  #
  # @response_field [Integer] id
  # @response_field [Integer] service_id
  # @response_field [Integer] host_id
  # @response_field [String]  name
  # @response_field [String]  info
  # @response_field [Date]    exploited_at
  # @response_field [String]  vuln_detail_count
  # @response_field [String]  vuln_attempt_count
  # @response_field [String]  nexpose_data_vuln_def_id
  # @response_field [Date]    created_at
  # @response_field [Date]    updated_at
  #
  def show
    if vuln_valid?
      @vuln = vuln_found
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

  def vuln_valid?
    ancestors_valid? && vuln_results.present?
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

  def vulns_found
    ::Mdm::Vuln.where(service_id: params['service_id'])
  end

  def vuln_found
    vuln_results.first
  end

  def vuln_results
    ::Mdm::Vuln.where('id = ? AND service_id = ?',
                         params['id'],
                         params['service_id'])
  end

end
