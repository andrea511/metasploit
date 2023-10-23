class AddHiddenToApps < ActiveRecord::Migration[4.2]
  def change
    add_column :apps, :hidden, :boolean, default: false
  end
end
