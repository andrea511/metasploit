class RemovingSiteIdFromVulnerabilities < ActiveRecord::Migration[4.2]
  def up
    remove_column :nexpose_data_vulnerabilities, :nexpose_data_site_id
  end

  def down
    add_column :nexpose_data_vulnerabilities, :nexpose_data_site_id, :integer
    add_index :nexpose_data_vulnerabilities, :nexpose_data_site_id
  end
end
