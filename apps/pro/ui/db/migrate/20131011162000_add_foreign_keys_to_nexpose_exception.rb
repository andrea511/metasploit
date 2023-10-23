class AddForeignKeysToNexposeException < ActiveRecord::Migration[4.2]
  def change
    add_column :nexpose_result_exceptions, :vuln_id, :integer
    add_column :nexpose_result_exceptions, :module_detail_id, :integer
    add_column :nexpose_result_exceptions, :nexpose_data_exploit_id, :integer
  end
end
