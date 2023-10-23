class CreateNexposeDataIpAddress < ActiveRecord::Migration[4.2]
  def change
    create_table :nexpose_data_ip_addresses do |t|
      t.integer :nexpose_data_asset_id
      # t.inet :address

      t.timestamps null: false
    end
    add_column :nexpose_data_ip_addresses, :address, :inet
    add_index :nexpose_data_ip_addresses, :nexpose_data_asset_id
  end
end
