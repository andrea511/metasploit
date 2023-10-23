# @restful_api 2.0

class RestApi::V2::SessionsController < RestApi::V2::BaseController

  # @url /rest_api/v2/workspaces/:workspace_id/hosts/:host_id/sessions
  # @action GET
  #
  # Returns list of sessions for given host.
  #
  # @required [Integer] workspace_id
  # @required [Integer] host_id
  #
  # @response [Array<Mdm::Session>]
  #
  def index
    if ancestors_valid?
      @sessions = sessions_found
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  # @url /rest_api/v2/workspaces/:workspace_id/hosts/:host_id/sessions/:id
  # @action GET
  #
  # Returns a session by id.
  #
  # @required [Integer] workspace_id
  # @required [Integer] host_id
  # @required [Integer] id
  #
  # @response_field [Integer] id
  # @response_field [Integer] host_id
  # @response_field [String]  stype
  # @response_field [String]  via_exploit
  # @response_field [String]  via_payload
  # @response_field [String]  desc
  # @response_field [Integer] port
  # @response_field [String]  platform
  # @response_field [String]  datastore
  # @response_field [String]  close_reason
  # @response_field [Integer] local_id
  # @response_field [Integer] module_run_id
  # @response_field [Date]    last_seen
  # @response_field [Integer] campaign_id
  # @response_field [Date]    opened_at
  # @response_field [Date]    closed_at
  #
  def show
    if workspace_valid?
      @session = session_found
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  private

  def ancestors_valid?
    workspace_found.present? && host_found.present?
  end

  def workspace_valid?
    ancestors_valid? && session_results.present?
  end

  def workspace_found
    ::Mdm::Workspace.where(id: params['workspace_id'])
  end

  def host_found
    ::Mdm::Host.where('id = ? AND workspace_id = ?',
                      params['host_id'],
                      params['workspace_id'])
  end

  def sessions_found
    ::Mdm::Session.where(host_id: params['host_id'])
  end

  def session_found
    session_results.first
  end

  def session_results
    ::Mdm::Session.where('id = ? AND host_id = ?',
                         params['id'],
                         params['host_id'])
  end
end
