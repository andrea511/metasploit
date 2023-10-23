class AddCampaignLastTargetInteractionTimestamp < ActiveRecord::Migration[4.2]
  def up
    add_column :se_campaigns, :last_target_interaction_at, :timestamp
  end

  def down
    remove_column :se_campaigns, :last_target_interaction_at
  end
end
