class CreateScheduledTasks < ActiveRecord::Migration[4.2]
  def change
    create_table :scheduled_tasks do |t|
      t.string :kind
      t.datetime :last_run_at
      t.string :state
      t.string :last_run_status
      t.integer :task_chain_id
      t.integer :position
      t.text :config_hash

      t.timestamps null: false
    end
  end
end
