class AddActiveReportIdToTaskChain < ActiveRecord::Migration[4.2]
  def change
    add_column :task_chains, :active_report_id, :integer
  end
end
