class AddNotificationsToCampaigns < ActiveRecord::Migration[4.2]
  def change
    add_column :se_campaigns, :notification_enabled, :boolean
    add_column :se_campaigns, :notification_email_address, :string
    add_column :se_campaigns, :notification_email_message, :text
  end
end
