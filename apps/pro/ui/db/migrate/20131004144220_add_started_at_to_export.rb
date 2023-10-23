class AddStartedAtToExport < ActiveRecord::Migration[4.2]
  def change
    add_column :exports, :started_at, :timestamp
  end
end
