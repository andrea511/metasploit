class AddingStatusMessageToSeEmailSend < ActiveRecord::Migration[4.2]
  def change
    add_column :se_email_sends, :sent, :boolean
    add_column :se_email_sends, :status_message, :string
  end
end
