class CreateAppRuns < ActiveRecord::Migration[4.2]
  def change
    create_table :app_runs do |t|
      t.datetime :started_at
      t.datetime :stopped_at
      t.integer  :task_id
      t.integer  :app_id
      t.text   :config

      t.timestamps null: false
    end

    # Have to add the JSON column after-the-fact due to a bug
    #   in Rails 3 migration support for :json col type
    add_index  :app_runs, :task_id
    add_index  :app_runs, :app_id
  end
end
