class ModifingNexposeResultValidation < ActiveRecord::Migration[4.2]
  def up
    remove_column :nexpose_result_validations, :module_detail_id
    add_column :nexpose_result_validations, :sent_to_nexpose, :boolean
    add_column :nexpose_result_validations, :sent_at, :datetime
  end

  def down
    remove_column :nexpose_result_validations, :sent_to_nexpose
    remove_column :nexpose_result_validations, :sent_at
    add_column :nexpose_result_validations, :module_detail_id, :integer
  end
end
