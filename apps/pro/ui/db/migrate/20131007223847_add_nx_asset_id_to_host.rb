class AddNxAssetIdToHost < ActiveRecord::Migration[4.2]
  def change
    add_column :hosts, :nexpose_data_asset_id, :integer
  end
end
