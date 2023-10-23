class RemovingMsgSentCountFromSeEmails < ActiveRecord::Migration[4.2]
  def up
    remove_column :se_emails, :msg_sent_count
  end

  def down
    add_column :se_emails, :msg_sent_count, :integer
  end
end
