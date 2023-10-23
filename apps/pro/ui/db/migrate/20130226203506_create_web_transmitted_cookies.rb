class CreateWebTransmittedCookies < ActiveRecord::Migration[4.2]
  def change
    create_table :web_transmitted_cookies do |t|
      t.boolean :transmitted
      t.integer :request_id
      t.integer :cookie_id

      t.timestamps null: false
    end
  end
end
