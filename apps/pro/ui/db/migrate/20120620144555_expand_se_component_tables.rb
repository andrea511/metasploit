class ExpandSeComponentTables < ActiveRecord::Migration[4.2]
  def up
    add_column :se_emails, :prefs, :text
    add_column :se_web_pages, :prefs, :text
    add_column :se_usb_keys, :prefs, :text
  end

  def down
    remove_column :se_emails, :prefs
    remove_column :se_web_pages, :prefs
    remove_column :se_usb_keys, :prefs
  end
end
