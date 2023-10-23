class FixSerializeColumnOnScheduledTask < ActiveRecord::Migration[4.2]
  def up
    change_column :scheduled_tasks, :form_hash, :text, null: true
    change_column :task_chains, :legacy, :boolean, default: true
    #To cover those who ran the previous broken migration
    TaskChain.update_all legacy: true
  end

  def down
    #Nothing to do
  end
end
