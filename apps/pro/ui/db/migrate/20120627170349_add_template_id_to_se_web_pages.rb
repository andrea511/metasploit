class AddTemplateIdToSeWebPages < ActiveRecord::Migration[4.2]
  def up
    add_column :se_web_pages, :template_id, :integer
  end

  def down
    remove_column :se_web_pages, :template_id
  end
end
