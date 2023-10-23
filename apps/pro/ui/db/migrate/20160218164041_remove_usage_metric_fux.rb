class RemoveUsageMetricFux < ActiveRecord::Migration[4.2]
  def self.up
    BannerMessage.find_by(:name => "usage_metrics_announcement").destroy
  end
end
