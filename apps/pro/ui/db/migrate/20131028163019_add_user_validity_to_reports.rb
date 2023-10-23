class AddUserValidityToReports < ActiveRecord::Migration[4.2]
  def change
    add_column :reports, :usernames_reported, :text
    add_column :reports, :skip_data_check, :boolean, default: false
  end
end
