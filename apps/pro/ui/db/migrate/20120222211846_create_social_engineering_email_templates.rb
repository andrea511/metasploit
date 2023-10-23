class CreateSocialEngineeringEmailTemplates < ActiveRecord::Migration[4.2]
  def change
    create_table :se_email_templates do |t|
      t.integer :user_id
      t.text :content
      t.string :name
      t.integer :workspace_id

      t.timestamps null: false
    end
  end
end
