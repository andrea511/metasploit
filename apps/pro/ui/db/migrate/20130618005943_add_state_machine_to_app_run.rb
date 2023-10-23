class AddStateMachineToAppRun < ActiveRecord::Migration[4.2]
  def change
    add_column :app_runs, :state, :string
  end
end
