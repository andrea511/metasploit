class AddSerializeColumnToScheduledTask < ActiveRecord::Migration[4.2]
  def up
    add_column :scheduled_tasks, :form_hash, :text
    add_column :task_chains, :legacy, :boolean, default: true
  end

  def down
    remove_column :scheduled_tasks, :form_hash
    remove_column :task_chains, :legacy
  end
end
