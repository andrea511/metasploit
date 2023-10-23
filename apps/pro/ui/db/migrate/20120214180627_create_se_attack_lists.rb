class CreateSeAttackLists < ActiveRecord::Migration[4.2]
  def change
    create_table :se_attack_lists do |t|
      t.string :name
      t.string :file_name
      t.integer :user_id
      t.integer :workspace_id

      t.timestamps null: false
    end
  end
end
