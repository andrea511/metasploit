class UsageMetric < ApplicationRecord

  def self.first_metric_created_at
    where(key: 'enabled').first_or_create(value: 'n').created_at
  end

  def self.collection_date
    first_metric_created_at + 7.days
  end

  def self.seven_days?
    Time.now > collection_date
  end

  def self.days_until_collection
    (collection_date.to_date - Time.now.to_date).to_i
  end
end
