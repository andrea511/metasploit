class ChangeServerityToSeverity < ActiveRecord::Migration[4.2]
  def change
    rename_column :nexpose_data_vulnerability_definitions, :serverity, :severity
  end
end
