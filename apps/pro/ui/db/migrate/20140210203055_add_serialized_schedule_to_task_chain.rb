class AddSerializedScheduleToTaskChain < ActiveRecord::Migration[4.2]
  def change
    add_column :task_chains, :schedule_hash, :text
  end
end
