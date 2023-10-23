class AddDynamicStagersToPortableFiles < ActiveRecord::Migration[4.2]
  def up
    add_column :se_portable_files, :dynamic_stagers, :boolean, default: false
  end

  def down
    remove_column :se_portable_files, :dynamic_stagers
  end
end
