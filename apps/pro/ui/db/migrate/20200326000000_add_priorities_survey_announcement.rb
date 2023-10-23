class AddPrioritiesSurveyAnnouncement < ActiveRecord::Migration[4.2]
  def self.up
    BannerMessage.create(name: "priorities_survey_announcement")
  end

  def self.down
    BannerMessage.find_by(name: "priorities_survey_announcement").delete
  end
end
