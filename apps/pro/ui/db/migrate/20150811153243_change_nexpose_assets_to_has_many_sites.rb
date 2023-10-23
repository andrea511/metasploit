class ChangeNexposeAssetsToHasManySites < ActiveRecord::Migration[4.2]
  def up
    create_table 'nexpose_data_assets_sites', :id => false do |t|
      t.column :nexpose_data_asset_id, :integer
      t.column :nexpose_data_site_id, :integer
    end

    add_index(:nexpose_data_assets_sites, [:nexpose_data_asset_id, :nexpose_data_site_id], unique: true, name: :by_asset_site)

    #Migrate all existing records
    ::Nexpose::Data::Asset.all.each do | asset |
      site = ::Nexpose::Data::Site.find(asset.nexpose_data_site_id)
      asset.sites << site
      asset.save
    end

    remove_column :nexpose_data_assets, :nexpose_data_site_id
  end

  def down

  end
end
