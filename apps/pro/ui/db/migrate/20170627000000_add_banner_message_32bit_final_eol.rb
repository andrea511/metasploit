class AddBannerMessage32bitFinalEol < ActiveRecord::Migration[4.2]
  def self.up
    if ['metasploit'].pack('p').size == 4
      BannerMessage.create(name: "eol_for_32bit_systems")
    end
  end

  def self.down
    if ['metasploit'].pack('p').size == 4
      BannerMessage.find_by(name: "eol_for_32bit_systems").delete
    end
  end
end
