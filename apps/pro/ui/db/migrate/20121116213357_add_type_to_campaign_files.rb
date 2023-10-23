class AddTypeToCampaignFiles < ActiveRecord::Migration[4.2]
  def change
    add_column :se_campaign_files, :type, :string
  end
end
