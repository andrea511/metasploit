class AddAdminToBannerMessage < ActiveRecord::Migration[4.2]

  def up
    add_column :banner_messages, :admin, :boolean
    db.execute "UPDATE banner_messages SET admin = TRUE WHERE name = 'usage_metrics_announcement' "
  end

  def down
    remove_column :banner_messages, :admin
  end

  private

  def db
    ApplicationRecord.connection
  end
end
