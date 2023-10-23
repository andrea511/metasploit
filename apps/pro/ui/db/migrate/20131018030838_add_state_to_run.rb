class AddStateToRun < ActiveRecord::Migration[4.2]
  def change
    add_column :automatic_exploitation_runs, :state, :string
  end
end
