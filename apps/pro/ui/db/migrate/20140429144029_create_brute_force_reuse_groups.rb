class CreateBruteForceReuseGroups < ActiveRecord::Migration[4.2]
  def change
    create_table :brute_force_reuse_groups do |t|
      #
      # Columns
      #

      t.string :name, null: false

      #
      # Foreign keys
      #

      t.references :workspace, null: false

      #
      # timestamps null: false
      #

      t.timestamps null: false
    end

    add_index :brute_force_reuse_groups, [:workspace_id, :name], unique: true
  end
end
