class AddAddressStringsToExport < ActiveRecord::Migration[4.2]
  def change
    add_column :exports, :included_addresses, :text
    add_column :exports, :excluded_addresses, :text
  end
end
