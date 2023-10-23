class CreateUsageMetricsTable < ActiveRecord::Migration[4.2]
  def up
    create_table :usage_metrics do |t|
      t.string :key, :null => false
      t.string :value, :null => false
    end
  end

  def down
    drop_table :usage_metrics
  end
end
