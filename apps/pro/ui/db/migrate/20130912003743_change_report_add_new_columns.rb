class ChangeReportAddNewColumns < ActiveRecord::Migration[4.2]
  def change
    add_column :reports, :file_formats, :string
    add_column :reports, :options, :text
    add_column :reports, :sections, :string
    add_column :reports, :report_template, :string
    add_column :reports, :addresses, :text
  end
end
