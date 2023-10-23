class RenameNotificationMessagesVisibleToRead < ActiveRecord::Migration[4.2]
  def change
    rename_column :notification_messages_users, :visible, :read
    change_column :notification_messages_users, :read, :boolean, :default => false
  end
end
