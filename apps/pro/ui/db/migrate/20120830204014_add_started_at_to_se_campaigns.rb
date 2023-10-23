class AddStartedAtToSeCampaigns < ActiveRecord::Migration[4.2]
  def change
    add_column :se_campaigns, :started_at, :datetime
  end
end
