class UpdateWebTemplatesModel < ActiveRecord::Migration[4.2]
  def up
    add_column :se_web_templates, :content, :text
    remove_column :se_web_templates, :source
    remove_column :se_web_templates, :text_input
  end

  def down
    remove_column :se_web_templates, :content
    add_column :se_web_templates, :source, :string
    add_column :se_web_templates, :text_input, :string
  end
end
