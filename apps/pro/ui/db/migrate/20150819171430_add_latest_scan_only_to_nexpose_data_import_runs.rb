class AddLatestScanOnlyToNexposeDataImportRuns < ActiveRecord::Migration[4.2]
  def change
    add_column :nexpose_data_import_runs, :latest_scan_only, :boolean, default: false
  end
end
