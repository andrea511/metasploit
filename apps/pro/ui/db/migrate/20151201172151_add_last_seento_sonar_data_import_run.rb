class AddLastSeentoSonarDataImportRun < ActiveRecord::Migration[4.2]
  def change
    add_column :sonar_data_import_runs, :last_seen, :integer, default: 30
  end
end
