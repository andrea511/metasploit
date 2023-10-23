class AddDepthToMmDominoNodes < ActiveRecord::Migration[4.2]
  def change
    add_column :mm_domino_nodes, :depth, :integer, default: 0
  end
end
