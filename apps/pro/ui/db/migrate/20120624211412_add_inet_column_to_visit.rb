class AddInetColumnToVisit < ActiveRecord::Migration[4.2]
  def up
    add_column :se_visits, :address, :inet
  end

  def down
    remove_column :se_visits, :address
  end

end
