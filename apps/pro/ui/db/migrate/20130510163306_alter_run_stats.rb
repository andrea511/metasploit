class AlterRunStats < ActiveRecord::Migration[4.2]
  def up
    rename_column :run_stats, :measurable_id, :task_id
    remove_column :run_stats, :measurable_type
  end

  def down
    rename_column :run_stats, :task_id, :measurable_id
    add_column :run_stats, :measurable_type, :integer
  end
end
