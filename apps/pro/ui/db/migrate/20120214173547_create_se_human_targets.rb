class CreateSeHumanTargets < ActiveRecord::Migration[4.2]
  def change
    create_table :se_human_targets do |t|
      t.string :first_name
      t.string :last_name
      t.string :email_address
      t.integer :workspace_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
