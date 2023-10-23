class CreateNexposeDataScanTemplates < ActiveRecord::Migration[4.2]
  def change
    create_table :nexpose_data_scan_templates do |t|
      t.integer :nx_console_id, null: false
      t.string :scan_template_id, null: false
      t.string :name

      t.timestamps null: false
    end
    add_index :nexpose_data_scan_templates, :nx_console_id
    add_index :nexpose_data_scan_templates, :scan_template_id
  end
end
