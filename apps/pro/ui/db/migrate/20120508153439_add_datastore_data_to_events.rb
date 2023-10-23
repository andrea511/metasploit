class AddDatastoreDataToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :module_rhost, :text

    add_column :events, :module_name, :text

  end
end
