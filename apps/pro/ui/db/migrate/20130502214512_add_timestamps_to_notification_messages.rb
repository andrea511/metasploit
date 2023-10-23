class AddTimestampsToNotificationMessages < ActiveRecord::Migration[4.2]
  def change
    add_column(:notification_messages, :created_at, :datetime)
  end
end
