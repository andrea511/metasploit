class CreateBruteForceRuns < ActiveRecord::Migration[4.2]
  def change
    create_table :brute_force_runs do |t|
      t.text :config, null: false

      t.timestamps null: false
    end
  end
end
