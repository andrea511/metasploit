class AddStateToSeCampaigns < ActiveRecord::Migration[4.2]
  def change
    add_column :se_campaigns, :state, :string, :default => 'unconfigured'
  end
end
