class AddIndexesToSocialEngineering < ActiveRecord::Migration[4.2]
  def change
    add_index :se_email_sends, [:email_id, :human_target_id, :sent]
  end
end
