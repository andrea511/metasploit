class RemoveExportRunConsole < ActiveRecord::Migration[4.2]
  def change
    remove_column :nexpose_result_export_runs, :nx_console_id, :integer
  end
end
