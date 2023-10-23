class AddLastRunTaskAndReportToTaskChains < ActiveRecord::Migration[4.2]
  def change
    add_column :task_chains, :last_run_task_id, :integer
    add_column :task_chains, :last_run_report_id, :integer
  end
end
