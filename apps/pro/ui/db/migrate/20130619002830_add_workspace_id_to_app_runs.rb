class AddWorkspaceIdToAppRuns < ActiveRecord::Migration[4.2]
  def change
    add_column :app_runs, :workspace_id, :integer
    add_index :app_runs, :workspace_id
  end
end
