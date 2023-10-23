module TaskConfig::Workspace
  extend ActiveSupport::Concern

  #
  # Instance Methods
  #

  attr_reader :workspace

  def workspace=(workspace)
    @workspace = workspace

    if workspace.nil?
      @workspace_id = nil
    else
      @workspace_id = workspace.id
    end
  end

  attr_reader :workspace_id

  def workspace_id=(workspace_id)
    if workspace_id.present?
      @workspace_id = workspace_id.to_i
      @workspace = Mdm::Workspace.find(@workspace_id)
    else
      @workspace_id = nil
      @workspace = nil
    end
  end
end