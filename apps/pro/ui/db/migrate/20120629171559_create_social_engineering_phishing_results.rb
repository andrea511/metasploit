class CreateSocialEngineeringPhishingResults < ActiveRecord::Migration[4.2]
  def change
    create_table :se_phishing_results do |t|
      t.integer :human_target_id
      t.integer :web_page_id
      t.text :data

      t.timestamps null: false
    end
  end
end
