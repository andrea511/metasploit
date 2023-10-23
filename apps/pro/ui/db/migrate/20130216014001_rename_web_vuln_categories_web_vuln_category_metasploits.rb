# Renames web_vuln_categories to web_vuln_category_metasploits so that it allows other web_vuln_category_* tables
# for other {Web::VulnCategory} schemes, such as OWASP.
class RenameWebVulnCategoriesWebVulnCategoryMetasploits < ActiveRecord::Migration[4.2]
  #
  # CONSTANTS
  #

  OLD_COLUMN_NAME = :category
  OLD_TABLE_NAME = :web_vuln_categories
  NEW_COLUMN_NAME = :name
  NEW_TABLE_NAME = :web_vuln_category_metasploits

  # @return [void]
  def down
    create_table OLD_TABLE_NAME do |t|
      t.text OLD_COLUMN_NAME, :null => true
    end

    change_table OLD_TABLE_NAME do |t|
      t.index OLD_COLUMN_NAME, :unique => true
    end

    drop_table NEW_TABLE_NAME
  end

  # @return [void]
  def up
    create_table NEW_TABLE_NAME do |t|
      t.string NEW_COLUMN_NAME, :null => false
    end

    change_table NEW_TABLE_NAME do |t|
      t.index NEW_COLUMN_NAME, :unique => true
    end

    drop_table OLD_TABLE_NAME
  end
end
