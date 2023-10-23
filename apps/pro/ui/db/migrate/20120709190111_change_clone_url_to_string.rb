class ChangeCloneUrlToString < ActiveRecord::Migration[4.2]
  def up
    change_column :se_web_pages, :clone_url, :string
  end

  def down
    change_column :se_web_pages, :clone_url, :text
  end
end
