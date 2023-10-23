class ChangeMdmHostToHasManyAssets < ActiveRecord::Migration[4.2]
  def up
    create_table 'hosts_nexpose_data_assets', :id => false do |t|
      t.column :host_id, :integer
      t.column :nexpose_data_asset_id, :integer
    end

    add_index(:hosts_nexpose_data_assets, [:host_id,:nexpose_data_asset_id], unique: true, name: :by_host_assets)

    #Migrate all existing records
    Mdm::Host.all.each do | host |
      unless host.nexpose_data_asset_id.nil?
        asset = ::Nexpose::Data::Asset.find(host.nexpose_data_asset_id)
        asset.mdm_hosts << host
        asset.save
      end
    end

    remove_column :hosts, :nexpose_data_asset_id
  end

  def down

  end
end
