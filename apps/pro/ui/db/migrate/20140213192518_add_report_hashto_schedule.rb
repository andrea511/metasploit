class AddReportHashtoSchedule < ActiveRecord::Migration[4.2]
  def change
    add_column :scheduled_tasks, :report_hash, :text
  end
end
