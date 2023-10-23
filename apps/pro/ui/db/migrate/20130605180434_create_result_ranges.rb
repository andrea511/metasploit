class CreateResultRanges < ActiveRecord::Migration[4.2]
  def change
    create_table :egadz_result_ranges do |t|
      t.integer :task_id
      t.string :target_ip_address
      t.integer :start_port
      t.integer :end_port
      t.boolean :open

      t.timestamps null: false
    end
  end
end
