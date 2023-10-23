class FixVisitsTable < ActiveRecord::Migration[4.2]
  def up
    add_column :se_visits, :email_id, :integer
    remove_column :se_visits, :tracking_link_id
  end

  def down
    remove_column :se_visits, :email_id
    add_column :se_visits, :tracking_link_id, :integer
  end
end
