class AddDurationToReport < ActiveRecord::Migration[4.2]
  def change
    add_column :reports, :started_at, :timestamp
    add_column :reports, :completed_at, :timestamp
  end
end
