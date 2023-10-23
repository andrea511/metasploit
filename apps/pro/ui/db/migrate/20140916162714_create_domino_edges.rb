class CreateDominoEdges < ActiveRecord::Migration[4.2]

  TABLE_NAME = :mm_domino_edges

  def up

    # Create the columns
    create_table TABLE_NAME do |t|
      t.references :dest_node,   null: false
      t.references :login,       null: false      
      t.references :run,         null: false
      t.references :source_node, null: false

      t.timestamps null: false
    end

    # Add some indices
    change_table TABLE_NAME do |t|
      # To improve lookup speed
      t.index [:run_id]

      # We never want two Edges that point to the same Node in the same Run
      t.index [:dest_node_id, :run_id], unique: true

      # We never want to use the same Login twice in the same Run
      t.index [:login_id, :run_id], unique: true
    end

  end

  def down
    drop_table TABLE_NAME
  end

end
