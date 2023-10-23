class AddLastRequestAtToUsers < ActiveRecord::Migration[4.2]

  def up
    add_column :users, :last_request_at, :datetime
    Mdm::User.update_all(last_request_at: Time.now)
  end

  def down
    remove_column :users, :last_request_at
  end

end
