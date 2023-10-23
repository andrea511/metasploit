class AddCloneUrlAndOriginTypeToWebTemplates < ActiveRecord::Migration[4.2]
  def change
  	add_column :se_web_templates, :clone_url, :string
  	add_column :se_web_templates, :origin_type, :string
  end
end
