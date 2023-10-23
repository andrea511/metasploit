class CreateBruteforceGuessCore < ActiveRecord::Migration[4.2]
  def change
    create_table :brute_force_guess_cores do |t|
      #
      # Foreign Keys
      #

      t.references :private,
                   null: true
      t.references :public,
                   null: true
      t.references :realm,
                   null: true
      t.references :workspace,
                   null: false
      #
      # timestamps null: false
      #

      t.timestamps null: false
    end


    change_table :brute_force_guess_cores do |t|
      #
      # Foreign Key Indices
      #
      t.index :private_id
      t.index :public_id
      t.index :realm_id
      t.index :workspace_id
    end
  end
end
