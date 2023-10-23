class AddNxVulnDefFkToMdmVuln < ActiveRecord::Migration[4.2]
  def change
    add_column :vulns, :nexpose_data_vuln_def_id, :integer
    add_index :vulns, :nexpose_data_vuln_def_id
  end

end
