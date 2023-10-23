class AddNewScanToNexposeDataImportRuns < ActiveRecord::Migration[4.2]
  def change
    add_column :nexpose_data_import_runs, :new_scan, :boolean

    add_index :nexpose_data_import_runs, :new_scan, where: "(new_scan IS NOT NULL)"
  end
end
