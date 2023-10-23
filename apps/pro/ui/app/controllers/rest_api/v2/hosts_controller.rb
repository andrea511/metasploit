# @restful_api 2.0

class RestApi::V2::HostsController < RestApi::V2::BaseController

  # @url /rest_api/v2/workspaces/:workspace_id/hosts
  # @action GET
  #
  # Returns list of hosts for given workspace.
  #
  # @required [Integer] workspace_id
  #
  # @response [Array<Mdm::Host>]
  #
  def index
    if ancestors_valid?
      @hosts = hosts_found
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  # @url /rest_api/v2/workspaces/:workspace_id/hosts/:id
  # @action GET
  #
  # Returns a host by id.
  #
  # @required [Integer] workspace_id
  # @required [Integer] id
  #
  # @response_field [Integer] id
  # @response_field [Integer] workspace_id
  # @response_field [String]  address
  # @response_field [String]  mac
  # @response_field [String]  comm
  # @response_field [String]  name
  # @response_field [String]  state
  # @response_field [String]  os_name
  # @response_field [String]  os_flavor
  # @response_field [String]  os_sp
  # @response_field [String]  os_lang
  # @response_field [String]  arch
  # @response_field [String]  purpose
  # @response_field [String]  info
  # @response_field [String]  comments
  # @response_field [String]  scope
  # @response_field [String]  virtual_host
  # @response_field [Integer] note_count
  # @response_field [Integer] vuln_count
  # @response_field [Integer] service_count
  # @response_field [Integer] host_detail_count
  # @response_field [Integer] exploit_attempt_count
  # @response_field [Integer] cred_count
  # @response_field [Integer] nexpose_data_asset_id
  # @response_field [Integer] history_count
  # @response_field [String]  detected_arch
  # @response_field [Date]    created_at
  # @response_field [Date]    updated_at
  #
  def show
    if host_valid?
      @host = host_found
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  private

  def ancestors_valid?
    workspace_found.present?
  end

  def host_valid?
    ancestors_valid? && host_results.present?
  end

  def workspace_found
    ::Mdm::Workspace.where(id: params['workspace_id'])
  end

  def hosts_found
    ::Mdm::Host.where(workspace_id: params['workspace_id'])
  end

  def host_found
    host_results.first
  end

  def host_results
    ::Mdm::Host.where('id = ? AND workspace_id = ?',
                      params['id'],
                      params['workspace_id'])
  end
end
