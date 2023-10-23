class CreateTaskChains < ActiveRecord::Migration[4.2]
  def change
    create_table :task_chains do |t|
      t.text :schedule
      t.string :name
      t.datetime :last_run_at
      t.datetime :next_run_at
      t.integer :user_id
      t.integer :workspace_id


      t.timestamps null: false
    end
  end
end
