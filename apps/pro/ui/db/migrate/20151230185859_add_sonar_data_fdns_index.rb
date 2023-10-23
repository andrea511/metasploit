class AddSonarDataFdnsIndex < ActiveRecord::Migration[4.2]
  def change
    add_index :sonar_data_fdns, [:import_run_id, :hostname, :address], unique: true
  end
end
