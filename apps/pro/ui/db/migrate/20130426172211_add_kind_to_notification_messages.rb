class AddKindToNotificationMessages < ActiveRecord::Migration[4.2]
  def change
    add_column :notification_messages, :kind, :string
  end
end
