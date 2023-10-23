class AddEmailFieldsToReports < ActiveRecord::Migration[4.2]
  def change
    add_column :reports, :email_recipients, :text
  end
end
