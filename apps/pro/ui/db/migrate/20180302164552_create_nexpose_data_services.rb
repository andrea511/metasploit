class CreateNexposeDataServices < ActiveRecord::Migration[4.2]
  def change
    create_table :nexpose_data_services do |t|
      t.integer  :nexpose_data_asset_id
      t.integer  :port
      t.string   :proto
      t.string   :name

      t.timestamps null: false
    end
    add_index :nexpose_data_services, :nexpose_data_asset_id
  end
end
