class AddTypeToWebPage < ActiveRecord::Migration[4.2]
  def change
  	add_column :se_web_pages, :origin_type, :string
  end
end
