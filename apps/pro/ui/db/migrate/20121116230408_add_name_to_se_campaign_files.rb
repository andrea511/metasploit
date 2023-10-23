class AddNameToSeCampaignFiles < ActiveRecord::Migration[4.2]
  def change
    add_column :se_campaign_files, :name, :string
  end
end
