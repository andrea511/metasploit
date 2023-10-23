class AddBannerMessageBackupRestore < ActiveRecord::Migration[4.2]
  def self.up
  end

  def self.down
    BannerMessage.find_by(name: "backup_restore_announcement").delete
  end
end
