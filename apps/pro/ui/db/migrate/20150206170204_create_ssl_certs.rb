class CreateSslCerts < ActiveRecord::Migration[4.2]
  def change
    create_table :ssl_certs do |t|
      t.string :name
      t.string :file
      t.integer :workspace_id, :null => false
      t.timestamps null: false
    end
  end
end
