class CreateRunStats < ActiveRecord::Migration[4.2]
  def change
    create_table :run_stats do |t|
      t.string :name
      t.float :data
      t.references :measurable, :polymorphic => true
      t.timestamps null: false
    end
  end
end
