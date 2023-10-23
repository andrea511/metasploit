class AddHiddenToTaskChain < ActiveRecord::Migration[4.2]
  def change
    add_column :task_chains, :hidden, :boolean, :default => false
  end
end
