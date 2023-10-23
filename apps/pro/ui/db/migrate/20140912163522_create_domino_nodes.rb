class CreateDominoNodes < ActiveRecord::Migration[4.2]

  TABLE_NAME = :mm_domino_nodes

  def up

    # Create the columns
    create_table TABLE_NAME do |t|
      t.references :run,  null: false
      t.references :host, null: false
      t.timestamps null: false
    end

    # Add some indices
    change_table TABLE_NAME do |t|
      t.index [:run_id]
      t.index [:host_id]

      # Add a db uniqueness constraint to ensure we have at most
      #  one unique host per run.
      t.index [:host_id, :run_id], unique: true
    end

  end

  def down
    drop_table TABLE_NAME
  end

end
