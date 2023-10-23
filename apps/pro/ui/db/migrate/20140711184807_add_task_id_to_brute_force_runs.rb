class AddTaskIdToBruteForceRuns < ActiveRecord::Migration[4.2]
  def change
    add_column :brute_force_runs, :task_id, :integer
  end
end
