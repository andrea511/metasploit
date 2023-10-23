class CreateWebTransmittedHeaders < ActiveRecord::Migration[4.2]
  def change
    create_table :web_transmitted_headers do |t|
      t.boolean :transmitted
      t.integer :request_id
      t.integer :header_id

      t.timestamps null: false
    end
  end
end
