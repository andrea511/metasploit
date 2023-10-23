class CreateNexposeDataImportRuns < ActiveRecord::Migration[4.2]
  def change
    create_table :nexpose_data_import_runs do |t|
      t.integer :user_id
      t.integer :workspace_id
      t.string :state
      t.integer :nx_console_id
      t.boolean :metasploitable_only, :default => true

      t.timestamps null: false
    end
    add_index :nexpose_data_import_runs, :nx_console_id
  end
end
