class AddFileSizeToSeCampaignFiles < ActiveRecord::Migration[4.2]
  def change
    add_column :se_campaign_files, :file_size, :integer
  end
end
