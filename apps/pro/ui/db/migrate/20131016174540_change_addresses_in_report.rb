class ChangeAddressesInReport < ActiveRecord::Migration[4.2]
  def change
    rename_column :reports, :addresses, :included_addresses
    add_column    :reports, :excluded_addresses, :text
  end
end
