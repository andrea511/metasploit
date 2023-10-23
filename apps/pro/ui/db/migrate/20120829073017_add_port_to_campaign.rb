class AddPortToCampaign < ActiveRecord::Migration[4.2]
  def change
    add_column :se_campaigns, :port, :integer
  end
end
