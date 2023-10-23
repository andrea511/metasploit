class CreateBannerMessageUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :banner_message_users do |t|
      t.integer :banner_message_id
      t.integer :user_id
      t.boolean :read

      t.timestamps null: false
    end
  end
end
