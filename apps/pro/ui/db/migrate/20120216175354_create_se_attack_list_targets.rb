class CreateSeAttackListTargets < ActiveRecord::Migration[4.2]
  def change
    create_table :se_attack_list_human_targets do |t|
      t.integer :attack_list_id
      t.integer :human_target_id

      t.timestamps null: false
    end
  end
end
