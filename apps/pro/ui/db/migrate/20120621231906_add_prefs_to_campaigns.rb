class AddPrefsToCampaigns < ActiveRecord::Migration[4.2]
  def up
    add_column :se_campaigns, :prefs, :text
  end

  def down
    remove_column :se_campaigns, :prefs
  end
end
