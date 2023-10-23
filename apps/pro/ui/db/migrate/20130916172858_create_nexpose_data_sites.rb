class CreateNexposeDataSites < ActiveRecord::Migration[4.2]
  def change
    create_table :nexpose_data_sites do |t|
      t.integer :nexpose_data_import_run_id, :null => false
      t.string :site_id, :null => false
      t.string :name
      t.text :description
      t.string :importance
      t.string :type
      t.datetime :last_scan_date
      t.datetime :next_scan_date
      t.string :last_scan_id
      t.text :summary
      t.timestamps null: false
    end
    add_index :nexpose_data_sites, :nexpose_data_import_run_id
    add_index :nexpose_data_sites, :site_id    
  end
end
