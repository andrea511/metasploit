class CreateDominoNodesCoresTable < ActiveRecord::Migration[4.2]
  def up
    create_table :mm_domino_nodes_cores do |t|
      t.integer :node_id, :null => false
      t.integer :core_id, :null => false
    end

    change_table :mm_domino_nodes_cores do |t|
      t.index [:node_id, :core_id]
    end
  end

  def down
    drop_table :mm_domino_nodes_cores
  end
end
