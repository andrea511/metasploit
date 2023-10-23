class AddingImportStateToImportRun < ActiveRecord::Migration[4.2]
  def change 
    add_column :nexpose_data_import_runs, :import_state, :string
  end

end
