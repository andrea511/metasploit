class ChangeMetasploitablyOnlyToDefaultFalse < ActiveRecord::Migration[4.2]
  def up
    change_column_default :nexpose_data_import_runs, :metasploitable_only, false
  end

  def down
    change_column_default :nexpose_data_import_runs, :metasploitable_only, true
  end
end
