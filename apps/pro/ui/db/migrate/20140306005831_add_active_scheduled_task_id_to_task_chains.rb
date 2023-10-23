class AddActiveScheduledTaskIdToTaskChains < ActiveRecord::Migration[4.2]
  def change
    add_column :task_chains, :active_scheduled_task_id, :integer
  end
end
