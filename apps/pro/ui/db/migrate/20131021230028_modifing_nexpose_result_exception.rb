class ModifingNexposeResultException < ActiveRecord::Migration[4.2]
  def up
    add_column :nexpose_result_exceptions, :expiration_date, :datetime
    add_column :nexpose_result_exceptions, :reason, :string
    add_column :nexpose_result_exceptions, :comments, :text
    add_column :nexpose_result_exceptions, :approve, :boolean
    add_column :nexpose_result_exceptions, :sent_to_nexpose, :boolean
    add_column :nexpose_result_exceptions, :sent_at, :datetime
    remove_column :nexpose_result_exceptions, :vuln_id  
    remove_column :nexpose_result_exceptions, :module_detail_id
    remove_column :nexpose_result_exceptions, :nexpose_data_exploit_id
    remove_column :nexpose_result_exceptions, :port 
    remove_column :nexpose_result_exceptions, :action
  end

  def down
    add_column :nexpose_result_exceptions, :action, :string
    add_column :nexpose_result_exceptions, :port, :integer
    add_column :nexpose_result_exceptions, :nexpose_data_exploit_id, :integer
    add_column :nexpose_result_exceptions, :module_detail_id, :integer
    add_column :nexpose_result_exceptions, :vuln_id, :integer

    remove_column :nexpose_result_exceptions, :sent_at
    remove_column :nexpose_result_exceptions, :sent_to_nexpose
    remove_column :nexpose_result_exceptions, :approve
    remove_column :nexpose_result_exceptions, :comments
    remove_column :nexpose_result_exceptions, :reason
    remove_column :nexpose_result_exceptions, :expiration_date
  end
end
