class AddWorkspaceAndUserToCampaignFiles < ActiveRecord::Migration[4.2]
  def change
    add_column :se_campaign_files, :workspace_id, :integer
    add_column :se_campaign_files, :user_id, :integer
  end
end
