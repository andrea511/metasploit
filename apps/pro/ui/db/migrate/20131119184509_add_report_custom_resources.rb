class AddReportCustomResources < ActiveRecord::Migration[4.2]
  def up
    create_table :report_custom_resources do |t|
      t.integer :workspace_id, :null => false
      t.string  :created_by
      t.string  :resource_type
      t.string  :name
      t.string  :file_path
      t.timestamps null: false
    end 
  end

  def down
    drop_table :report_custom_resources
  end
end


