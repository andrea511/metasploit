class CreateSocialEngineeringWebPages < ActiveRecord::Migration[4.2]
  def change
    create_table :se_web_pages do |t|
      t.integer :campaign_id
      t.string :path
      t.text :content
      t.text :clone_url
      t.boolean :online

      t.timestamps null: false
    end
  end
end
