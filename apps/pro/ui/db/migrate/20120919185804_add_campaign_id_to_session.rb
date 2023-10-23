class AddCampaignIdToSession < ActiveRecord::Migration[4.2]
  def change
    add_column :sessions, :campaign_id, :integer
  end
end
