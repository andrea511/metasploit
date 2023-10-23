class AddHighValueToDominoNodes < ActiveRecord::Migration[4.2]

  def change
    add_column :mm_domino_nodes, :high_value, :boolean, default: false
  end

end
