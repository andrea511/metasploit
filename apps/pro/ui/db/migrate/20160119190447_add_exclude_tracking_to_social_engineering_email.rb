class AddExcludeTrackingToSocialEngineeringEmail < ActiveRecord::Migration[4.2]
  def up
    add_column :se_emails, :exclude_tracking, :boolean, default: false
  end

  def down
    remove_column :se_emails, :exclude_tracking
  end
end
