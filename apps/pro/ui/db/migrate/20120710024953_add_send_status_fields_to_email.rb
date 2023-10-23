class AddSendStatusFieldsToEmail < ActiveRecord::Migration[4.2]
  def change
    add_column :se_emails, :status, :string
    add_column :se_emails, :msg_sent_count, :int
    add_column :se_emails, :sent_at, :datetime
  end
end
