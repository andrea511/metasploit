class AddStateMachineToReport < ActiveRecord::Migration[4.2]
  def change
    add_column :reports, :state, :string
  end
end
