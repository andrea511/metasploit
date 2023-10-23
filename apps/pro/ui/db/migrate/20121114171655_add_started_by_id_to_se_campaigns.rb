class AddStartedByIdToSeCampaigns < ActiveRecord::Migration[4.2]
  def change
    add_column :se_campaigns, :started_by_user_id, :integer
  end
end
