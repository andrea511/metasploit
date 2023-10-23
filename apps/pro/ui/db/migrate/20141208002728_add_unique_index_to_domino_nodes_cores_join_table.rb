class AddUniqueIndexToDominoNodesCoresJoinTable < ActiveRecord::Migration[4.2]

  def change

    # in case you have any old data in there
    ApplicationRecord.connection.execute("DELETE FROM mm_domino_nodes_cores;")

    remove_index :mm_domino_nodes_cores, [:node_id, :core_id]
    add_index :mm_domino_nodes_cores, [:node_id, :core_id], unique: true

  end
end
