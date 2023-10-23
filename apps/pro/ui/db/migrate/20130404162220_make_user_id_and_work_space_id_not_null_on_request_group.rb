class MakeUserIdAndWorkSpaceIdNotNullOnRequestGroup < ActiveRecord::Migration[4.2]
  def change
    change_column :web_request_groups, :user_id, :integer, :null => false
    change_column :web_request_groups, :workspace_id, :integer, :null => false
  end
end
