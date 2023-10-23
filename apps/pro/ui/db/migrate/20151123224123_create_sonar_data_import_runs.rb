class CreateSonarDataImportRuns < ActiveRecord::Migration[4.2]
  def change
    create_table :sonar_data_import_runs do |t|
      t.references :user, index: true
      t.references :workspace, index: true
      t.string :domain

      t.timestamps null: false
    end
  end
end
