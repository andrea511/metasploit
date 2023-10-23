class CreateNotificationMessagesTable < ActiveRecord::Migration[4.2]
  def change
    create_table :notification_messages do |t|
      t.integer :workspace_id
      t.integer :task_id
      t.string  :title
      t.text    :content
      t.string  :url
    end

    create_table :notification_messages_users do |t|
      t.integer :user_id
      t.integer :message_id
      t.boolean :visible, :default => true
      t.timestamps null: false
    end
  end
end
