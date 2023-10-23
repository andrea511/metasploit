class AddLogoPathToReports < ActiveRecord::Migration[4.2]
  def change
    add_column :reports, :logo_path, :text
  end
end
