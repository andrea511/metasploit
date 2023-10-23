class AddExports < ActiveRecord::Migration[4.2]
  def up
    create_table :exports do |t|
      t.integer :workspace_id, :null => false
      t.string  :created_by
      t.string  :export_type
      t.string  :name
      t.string  :state
      t.timestamps null: false
    end 

  end

  def down
    drop_table :exports
  end
end
