class EnableProductNewsGlobalSetting < ActiveRecord::Migration[4.2]
  def up
    Mdm::Profile.all.each do |p|
      p.settings['enable_news_feed'] = true
      p.save!
    end
  end

  def down
    Mdm::Profile.all.each do |p|
      p.settings.delete('enable_news_feed')
      p.save!
    end
  end
end
