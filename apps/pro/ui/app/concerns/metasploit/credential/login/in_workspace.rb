module Metasploit::Credential::Login::InWorkspace
  extend ActiveSupport::Concern

  included do
    # Takes a Workspace ID and returns all Logins
    # found inside that Workspace.
    #
    # @param :workspace_id [Integer] the id of the {Mdm::Workspace}
    # @return [ActiveRecord::Relation] the Relation containing all the Logins in that Workspace
    def self.in_workspace(workspace_id)
      Metasploit::Credential::Login.joins(:host).where(hosts: { workspace_id: workspace_id })
    end
  end

end
