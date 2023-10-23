class CreateSonarDataFdns < ActiveRecord::Migration[4.2]
  def change
    create_table :sonar_data_fdns do |t|
      t.references :import_run, index: true
      t.string :hostname
      t.inet :address
      t.datetime :last_seen

      t.timestamps null: false
    end
  end
end
