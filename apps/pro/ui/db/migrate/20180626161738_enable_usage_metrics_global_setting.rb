class EnableUsageMetricsGlobalSetting < ActiveRecord::Migration[4.2]
  def up
    Mdm::Profile.all.each do |p|
      p.settings['usage_metrics_user_data'] = true
      p.save!
    end
  end

  def down
    Mdm::Profile.all.each do |p|
      p.settings.delete('usage_metrics_user_data')
      p.save!
    end
  end
end
