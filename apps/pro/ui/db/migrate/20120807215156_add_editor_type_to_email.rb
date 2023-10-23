class AddEditorTypeToEmail < ActiveRecord::Migration[4.2]
  def change
  	add_column :se_emails, :editor_type, :string
  end
end
