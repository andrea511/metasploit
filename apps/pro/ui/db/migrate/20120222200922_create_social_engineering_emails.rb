class CreateSocialEngineeringEmails < ActiveRecord::Migration[4.2]
  def change
    create_table :se_emails do |t|
      t.integer :user_id
      t.text :content
      t.string :name
      t.string :subject
      t.integer :campaign_id
      t.integer :template_id

      t.timestamps null: false
    end
  end
end
