class CreateNexposeResultValidations < ActiveRecord::Migration[4.2]
  def change
    create_table :nexpose_result_validations do |t|
      t.integer :user_id
      t.integer :run_id
      t.integer :nexpose_data_asset_id
      t.integer :module_detail_id
      t.datetime :verified_at

      t.timestamps null: false
    end
  end
end
