class AddBannerMessage32bitEol < ActiveRecord::Migration[4.2]
  def self.up
  end

  def self.down
    if ['metasploit'].pack('p').size == 4
      BannerMessage.find_by(name: "upcoming_eol_for_32bit_systems").delete
    end
  end
end
