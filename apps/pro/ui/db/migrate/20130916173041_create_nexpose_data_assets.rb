class CreateNexposeDataAssets < ActiveRecord::Migration[4.2]
  def change
    create_table :nexpose_data_assets do |t|
      t.integer :nexpose_data_site_id, :null => false
      t.string :asset_id, :null => false
      t.string :url
      t.text :host_names
      t.string :os_name
      t.text :mac_addresses
      t.datetime :last_scan_date
      t.datetime :next_scan_date
      t.string :last_scan_id
      t.timestamps null: false
    end
    add_index :nexpose_data_assets, :nexpose_data_site_id
    add_index :nexpose_data_assets, :asset_id
  end
end
