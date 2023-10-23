class CreateSocialEngineeringCampaigns < ActiveRecord::Migration[4.2]
  def change
    create_table :se_campaigns do |t|
      t.integer :user_id
      t.integer :workspace_id
      t.string :name

      t.timestamps null: false
    end
  end
end
