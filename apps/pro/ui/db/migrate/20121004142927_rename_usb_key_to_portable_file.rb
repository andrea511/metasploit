class RenameUsbKeyToPortableFile < ActiveRecord::Migration[4.2]
  def up
    rename_table :se_usb_keys, :se_portable_files
  end

  def down
    rename_table :se_portable_files, :se_usb_keys
  end
end
