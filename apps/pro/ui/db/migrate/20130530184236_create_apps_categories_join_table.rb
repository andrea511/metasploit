class CreateAppsCategoriesJoinTable < ActiveRecord::Migration[4.2]
  def change
    create_table :app_categories_apps do |t|
      t.integer :app_id
      t.integer :app_category_id
      t.string  :name
    end

    add_index :app_categories_apps, :app_id
    add_index :app_categories_apps, :app_category_id
  end
end
