class AddNotificationEmailSubjectToCampaigns < ActiveRecord::Migration[4.2]
  def change
    add_column :se_campaigns, :notification_email_subject, :string
  end
end
