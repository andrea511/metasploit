class AddMaskCredentialsToExports < ActiveRecord::Migration[4.2]
  def change
    add_column :exports, :mask_credentials, :boolean, :default => false
  end
end
