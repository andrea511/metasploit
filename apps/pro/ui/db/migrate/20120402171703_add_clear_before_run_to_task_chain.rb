class AddClearBeforeRunToTaskChain < ActiveRecord::Migration[4.2]
  def change
    add_column :task_chains, :clear_workspace_before_run, :boolean
  end
end
