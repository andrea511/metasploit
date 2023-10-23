class AddContentDispositionToCampaignFile < ActiveRecord::Migration[4.2]
  def change
    add_column :se_campaign_files, :content_disposition, :string
  end
end
