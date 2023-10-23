class CreateGeneratedPayloads < ActiveRecord::Migration[4.2]
  def change
    create_table :generated_payloads do |t|
      t.string  :state
      t.string  :file
      t.text    :options
      t.integer :workspace_id, null: true
      t.timestamps null: false
    end
  end
end
