class CreateWebVulnCategoryProjectionMetasploitOwasps < ActiveRecord::Migration[4.2]
  #
  # CONSTANTS
  #

  TABLE_NAME = :web_vuln_category_projection_metasploit_owasps

  # @return [void]
  def down
    drop_table TABLE_NAME
  end

  # @return [void]
  def up
    create_table TABLE_NAME do |t|
      t.references :metasploit, :null => false
      t.references :owasp, :null => false
    end

    change_table TABLE_NAME do |t|
      t.index [:metasploit_id, :owasp_id],
              :name => 'index_web_vuln_category_project_metasploit_id_and_owasp_id',
              :unique => true
    end
  end
end
