class CreateNexposeDataVulnerabilities < ActiveRecord::Migration[4.2]
  def change
    create_table :nexpose_data_vulnerabilities do |t|
      t.integer :nexpose_data_site_id, :null => false
      t.integer :nexpose_data_vulnerability_definition_id, :null => false
      t.string :vulnerability_id, :null => false
      t.string :title
      
      t.timestamps null: false
    end
    add_index :nexpose_data_vulnerabilities, :nexpose_data_site_id
    add_index :nexpose_data_vulnerabilities, :nexpose_data_vulnerability_definition_id,
              :name => "index_nx_data_vuln_on_nexpose_data_vuln_def_id"
    add_index :nexpose_data_vulnerabilities, :vulnerability_id, :unique => true
  end
end
