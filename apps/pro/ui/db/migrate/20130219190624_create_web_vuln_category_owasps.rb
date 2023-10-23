class CreateWebVulnCategoryOwasps < ActiveRecord::Migration[4.2]
  #
  # CONSTANTS
  #

  TABLE_NAME = :web_vuln_category_owasps

  # @return [void]
  def down
    drop_table TABLE_NAME
  end

  # @return [void]
  def up
    create_table TABLE_NAME do |t|
      t.string :detectability, :null => false
      t.string :exploitability, :null => false
      t.string :impact, :null => false
      t.string :name, :null => false
      t.string :prevalence, :null => false
      t.integer :rank, :null => false
      t.string :summary, :null => false
      t.string :target, :null => false
      t.string :version, :null => false
    end

    change_table TABLE_NAME do |t|
      t.index [:target, :version, :rank], :unique => true
    end
  end
end
