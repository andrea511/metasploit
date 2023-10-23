class CreateSocialEngineeringTrackingLinks < ActiveRecord::Migration[4.2]
  def change
    create_table :se_tracking_links do |t|
      t.string :external_destination_url
      t.integer :email_id
      t.integer :web_page_id

      t.timestamps null: false
    end
  end
end
