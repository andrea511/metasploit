class AddAddressToEmailOpening < ActiveRecord::Migration[4.2]
  def change
    add_column :se_email_openings, :address, :inet
  end
end
