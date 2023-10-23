class AddSummaryToWebVulnCategoryMetasploits < ActiveRecord::Migration[4.2]
  def change
    add_column :web_vuln_category_metasploits, :summary, :string, :null => false
  end
end
