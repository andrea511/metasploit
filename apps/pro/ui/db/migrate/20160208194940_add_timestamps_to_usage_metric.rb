class AddTimestampsToUsageMetric < ActiveRecord::Migration[4.2]
  def change
    add_column :usage_metrics, :created_at, :datetime
    add_column :usage_metrics, :updated_at, :datetime
  end
end
