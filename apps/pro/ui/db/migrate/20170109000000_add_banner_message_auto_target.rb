class AddBannerMessageAutoTarget < ActiveRecord::Migration[4.2]
  def self.up
  end

  def self.down
    BannerMessage.find_by(name: "auto_target_announcement").delete
  end
end
