class CreateAppCategories < ActiveRecord::Migration[4.2]
  def change
    create_table :app_categories do |t|
      t.integer :app_id
      t.string  :name
    end

    add_index :app_categories, :app_id
  end
end
