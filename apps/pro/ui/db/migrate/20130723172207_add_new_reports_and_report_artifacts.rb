class AddNewReportsAndReportArtifacts < ActiveRecord::Migration[4.2]

  def up
    # Remove old table (TODO: needs to convert old entries)
    drop_table :reports
    # Add new Reports
    create_table :reports do |t|
      t.integer :workspace_id, :null => false
      t.string  :created_by
      t.string  :report_type
      t.string  :name
      t.timestamps null: false
      #options - TODO, json or serialized
    end 
    
    # Add new ReportArtifacts
    create_table :report_artifacts do |t|
      t.integer :report_id, :null => false
      t.string  :file_path, :null => false, :limit => 1024
      t.timestamps null: false
    end 
  end

  def down
    drop_table :reports
    drop_table :report_artifacts
  end

end
