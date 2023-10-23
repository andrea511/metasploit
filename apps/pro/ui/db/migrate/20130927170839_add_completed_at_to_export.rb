class AddCompletedAtToExport < ActiveRecord::Migration[4.2]
  def change
    add_column :exports, :completed_at, :timestamp
  end
end
