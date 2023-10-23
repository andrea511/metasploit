class UpdatePortableFilesForReporting < ActiveRecord::Migration[4.2]
  def up
    add_column :se_portable_files, :file_name, :string
    add_column :se_portable_files, :exploit_module_path, :string
  end

  def down
    remove_column :se_portable_files, :file_name
    remove_column :se_portable_files, :exploit_module_path
  end
end
