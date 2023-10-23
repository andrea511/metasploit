class MoveMdmUserFromRequestToRequestGroup < ActiveRecord::Migration[4.2]
  def up
    remove_column :web_requests, :user_id
    add_column :web_request_groups, :user_id, :integer
    add_column :web_request_groups, :workspace_id, :integer
  end

  def down
    remove_column :web_request_groups, :workspace_id
    remove_column :web_request_groups, :user_id
    add_column :web_requests, :user_id, :integer
  end
end
