class AddConfigTypeToSocialEngineeringCampaigns < ActiveRecord::Migration[4.2]
  def change
    add_column :se_campaigns, :config_type, :string
  end
end
