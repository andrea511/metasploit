class CreateSocialEngineeringVisits < ActiveRecord::Migration[4.2]
  def change
    create_table :se_visits do |t|
      t.integer :human_target_id
      t.integer :tracking_link_id
      t.integer :web_page_id

      t.timestamps null: false
    end
  end
end
