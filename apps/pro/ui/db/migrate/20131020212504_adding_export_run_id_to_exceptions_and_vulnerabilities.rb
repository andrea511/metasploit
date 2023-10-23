class AddingExportRunIdToExceptionsAndVulnerabilities < ActiveRecord::Migration[4.2]
  def up
    add_column :nexpose_result_exceptions, :nexpose_result_export_run_id, :integer
    add_column :nexpose_result_validations, :nexpose_result_export_run_id, :integer
    add_index :nexpose_result_exceptions, :nexpose_result_export_run_id
    add_index :nexpose_result_validations, :nexpose_result_export_run_id,
              :name => "index_nx_result_validations_on_nx_result_export_run_id"
  end

  def down
    remove_index :nexpose_result_validations, :name => "index_nx_result_validations_on_nx_result_export_run_id"
    remove_index :nexpose_result_exceptions, :nexpose_result_export_run_id 
    remove_column :nexpose_result_validations, :nexpose_result_export_run_id
    remove_column :nexpose_result_exceptions, :nexpose_result_export_run_id
  end

end
