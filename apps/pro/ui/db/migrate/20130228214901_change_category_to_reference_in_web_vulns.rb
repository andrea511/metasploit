class ChangeCategoryToReferenceInWebVulns < ActiveRecord::Migration[4.2]
  TABLE_NAME = :web_vulns

  def down
    # Restore original name for column
    change_table TABLE_NAME do |t|
      t.rename :legacy_category, :category
    end

    execute "UPDATE web_vulns " \
            "SET category = web_vuln_category_metasploits.name " \
            "FROM web_vuln_category_metasploits " \
            "WHERE web_vuln_category_metasploits.id = web_vulns.category_id"

    # make category non-null now that it's filled
    change_column_null(TABLE_NAME, :category, false)

    # drop category_id now that category is translated from web_vuln_category_metasploits.name
    change_table TABLE_NAME do |t|
      t.remove_references :category
    end
  end

  def up
    # add category_id before renaming category so category can be transformed into category_id point to
    # web_vuln_category_metasploits.name of same value as category.
    change_table TABLE_NAME do |t|
      t.references :category
    end

    # AREL does not support UPDATE FROM syntax, so do this manually with strings
    # @see https://github.com/rails/arel/issues/111#issuecomment-5974506
    execute "UPDATE web_vulns " \
            "SET category_id = web_vuln_category_metasploits.id " \
            "FROM web_vuln_category_metasploits " \
            "WHERE web_vuln_category_metasploits.name = web_vulns.category"

    change_table TABLE_NAME do |t|
      # leave category column in legacy_category so that categories that did not map to
      # web_vuln_category_metasploit.names can be recoverd
      t.rename :category, :legacy_category
    end

    # New web_vulns won't have legacy_category filled, so make it :null => true
    change_column_null(TABLE_NAME, :legacy_category, true)
  end
end
