class AddHiddenToAppRuns < ActiveRecord::Migration[4.2]
  def change
    add_column :app_runs, :hidden, :boolean, default: false
  end
end
