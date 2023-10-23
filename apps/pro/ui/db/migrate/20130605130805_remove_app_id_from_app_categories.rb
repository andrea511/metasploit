class RemoveAppIdFromAppCategories < ActiveRecord::Migration[4.2]
  def change
    remove_column :app_categories, :app_id
  end
end
