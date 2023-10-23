class ChangeEgadzResultState < ActiveRecord::Migration[4.2]
  def up
    remove_column :egadz_result_ranges, :open
    add_column :egadz_result_ranges, :state, :string
  end
end
