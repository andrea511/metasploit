class DropOldReportTemplates < ActiveRecord::Migration[4.2]
  def up
    drop_table :report_templates
  end
end
