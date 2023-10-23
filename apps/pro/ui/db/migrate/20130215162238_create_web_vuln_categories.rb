# The web_vuln_categories table is used to keep the Mdm::WebVuln#category unique by replacing it with a cateogory_id
# that points to (deprecated) Web::VulnCategory#id.  This is a Pro-only feature that allows Pro to map the Metasploit
# web scanner categories to OWASP categories for reporting on OWASP Top Ten.
class CreateWebVulnCategories < ActiveRecord::Migration[4.2]
  #
  # CONSTANTS
  #
  TABLE_NAME = :web_vuln_categories

  # Remove the web_vuln_categories table to go back to the dupe filled system supported by metasploit-framework.
  def down
    drop_table TABLE_NAME
  end

  # Creates the web_vuln_categories table and makes the category column unique so there one id for each of the old
  # Mdm::WebVuln#category strings.
  #
  # @return [void]
  def up
    create_table TABLE_NAME do |t|
      t.text :category, :null => false
    end

    change_table TABLE_NAME do |t|
      t.index :category, :unique => true
    end
  end
end
