class CreateNexposeResultExceptions < ActiveRecord::Migration[4.2]
  def change
    create_table :nexpose_result_exceptions do |t|
      t.integer :run_id
      t.integer :user_id
      t.integer :port
      t.string :action
      t.string :nx_scope_type
      t.integer :nx_scope_id

      t.timestamps null: false
    end
    add_index :nexpose_result_exceptions, :run_id
    add_index :nexpose_result_exceptions, :user_id
    add_index :nexpose_result_exceptions, [:nx_scope_type,:nx_scope_id],
              name: 'index_nx_r_exceptions_on_nx_scope_type_and_nx_scope_id'
  end
end
