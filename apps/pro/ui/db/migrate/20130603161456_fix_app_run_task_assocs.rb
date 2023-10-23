class FixAppRunTaskAssocs < ActiveRecord::Migration[4.2]
  def change
    add_column :tasks, :app_run_id, :integer
    remove_column :app_runs, :task_id
  end
end
