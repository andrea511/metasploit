class AddFailedLoginCountToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :failed_login_count, :integer
  end
end
