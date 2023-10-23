class CreateEmailSends < ActiveRecord::Migration[4.2]
  def change
    create_table :se_email_sends do |t|
      t.integer :email_id
      t.integer :human_target_id

      t.timestamps null: false
    end
  end
end
