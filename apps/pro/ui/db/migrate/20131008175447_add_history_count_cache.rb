class AddHistoryCountCache < ActiveRecord::Migration[4.2]
  def up
    add_column :hosts,:history_count, :integer, :default => 0
    Mdm::Host.reset_column_information

  end

  def down
    remove_column :hosts, :history_count
  end
end
