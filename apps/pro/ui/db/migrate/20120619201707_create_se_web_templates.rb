class CreateSeWebTemplates < ActiveRecord::Migration[4.2]
  def up
    create_table :se_web_templates do |t|
      t.string  :name
      t.string  :source
      t.string  :text_input
      t.integer :workspace_id
      t.integer :user_id
      t.timestamps null: false
    end
  end

  def down
    drop_table :se_web_templates
  end
end
