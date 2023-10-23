class AddNameToWebPage < ActiveRecord::Migration[4.2]
  def up
    add_column :se_web_pages, :name, :string
  end

  def down
    remove_column :se_web_pages, :name
  end
end
