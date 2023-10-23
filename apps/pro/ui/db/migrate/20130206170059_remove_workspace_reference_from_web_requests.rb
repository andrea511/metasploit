# Remove workspace_id from web_requests as workspaces can be joins indirectly through virtual_host_id
class RemoveWorkspaceReferenceFromWebRequests < ActiveRecord::Migration[4.2]
  def up
    change_table :web_requests do |t|
      t.remove_references :workspace
    end
  end

  def down
    change_table :web_requests do |t|
      t.references :workspace, :null => false
    end
  end
end
