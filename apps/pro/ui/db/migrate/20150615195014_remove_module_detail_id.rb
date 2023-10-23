class RemoveModuleDetailId < ActiveRecord::Migration[4.2]
  def change
    remove_column :nexpose_data_exploits, :module_detail_id
  end
end
