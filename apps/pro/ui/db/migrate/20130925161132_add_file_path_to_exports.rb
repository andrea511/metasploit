class AddFilePathToExports < ActiveRecord::Migration[4.2]
  def change
    add_column :exports, :file_path, :string, :limit => 1024
  end
end
