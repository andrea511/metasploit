class AddStateToTaskChain < ActiveRecord::Migration[4.2]
  def change
    add_column :task_chains, :state, :string, :default => 'ready'
  end
end
