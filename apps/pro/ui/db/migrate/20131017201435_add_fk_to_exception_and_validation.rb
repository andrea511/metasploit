class AddFkToExceptionAndValidation < ActiveRecord::Migration[4.2]
  def up
    add_column :nexpose_result_exceptions, :automatic_exploitation_match_result_id, :integer
    add_column :nexpose_result_validations, :automatic_exploitation_match_result_id, :integer
    remove_column :nexpose_result_exceptions, :run_id
    remove_column :nexpose_result_validations, :run_id
  end
  def down
    add_column :nexpose_result_exceptions, :run_id, :integer
    add_index :nexpose_result_exceptions, :run_id
    add_column :nexpose_result_validations, :run_id, :integer
    remove_column :nexpose_result_validations, :automatic_exploitation_match_result_id
    remove_column :nexpose_result_exceptions, :automatic_exploitation_match_result_id
  end
  
end
