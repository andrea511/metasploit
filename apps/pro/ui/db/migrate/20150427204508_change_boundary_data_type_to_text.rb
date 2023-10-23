class ChangeBoundaryDataTypeToText < ActiveRecord::Migration[4.2]
  def up
    change_column :workspaces, :boundary, :text
  end

  def down
    change_column :workspaces, :boundary, :string, :limit => 4096
  end
end
