# @restful_api 2.0

class RestApi::V2::NotesController < RestApi::V2::BaseController

  # @url /rest_api/v2/workspaces/:workspace_id/hosts/:host_id/notes
  # @action GET
  #
  # Returns list of notes for given host.
  #
  # @required [Integer] workspace_id
  # @required [Integer] host_id
  #
  # @response [Array<Mdm::Note>]
  #
  def index
    if ancestors_valid?
      @notes = notes_found
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  # @url /rest_api/v2/workspaces/:workspace_id/hosts/:host_id/notes/:id
  # @action GET
  #
  # Returns a note by id.
  #
  # @required [Integer] workspace_id
  # @required [Integer] host_id
  # @required [Integer] id
  #
  # @response_field [Integer] id
  # @response_field [String]  ntype
  # @response_field [Integer] workspace_id
  # @response_field [Integer] vuln_id
  # @response_field [Integer] service_id
  # @response_field [Integer] host_id
  # @response_field [Boolean] critical
  # @response_field [Boolean] seen
  # @response_field [String]  data
  # @response_field [Date]    created_at
  # @response_field [Date]    updated_at
  #
  def show
    if note_valid?
      @note = note_found
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  private

  def ancestors_valid?
    workspace_found.present? && host_found.present?
  end

  def note_valid?
    ancestors_valid? && note_results.present?
  end


  def workspace_found
    ::Mdm::Workspace.where(id: params['workspace_id'])
  end

  def host_found
    ::Mdm::Host.where('id = ? AND workspace_id = ?',
                      params['host_id'],
                      params['workspace_id'])
  end

  def notes_found
    ::Mdm::Note.where(host_id: params['host_id'])
  end

  def note_found
    note_results.first
  end

  def note_results
    ::Mdm::Note.where('id = ? AND host_id = ?',
                         params['id'],
                         params['host_id'])
  end
end
