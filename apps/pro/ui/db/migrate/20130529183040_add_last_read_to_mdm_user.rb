class AddLastReadToMdmUser < ActiveRecord::Migration[4.2]
  def up
    add_column :users, :notification_center_count, :integer, :default => 0
  end

  def down
    remove_column :users, :notification_center_count
  end

end
