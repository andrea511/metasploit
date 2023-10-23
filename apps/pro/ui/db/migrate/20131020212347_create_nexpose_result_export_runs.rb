class CreateNexposeResultExportRuns < ActiveRecord::Migration[4.2]
  def change
    create_table :nexpose_result_export_runs do |t|
      t.string :state
      t.integer :nx_console_id
      t.integer :user_id
      t.integer :workspace_id

      t.timestamps null: false
    end
  end
end
