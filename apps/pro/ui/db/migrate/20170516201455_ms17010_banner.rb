class Ms17010Banner < ActiveRecord::Migration[4.2]
  def self.up
  end

  def self.down
    BannerMessage.find_by(name: "ms17_010_banner").delete
  end
end
