class RemoveHiddenFromTaskChains < ActiveRecord::Migration[4.2]
  def change
    remove_column :task_chains, :hidden
  end
end
