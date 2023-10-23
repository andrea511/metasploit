class RemovePrioritiesSurveyAnnouncement < ActiveRecord::Migration[4.2]
  def self.up
    BannerMessage.find_by(name: "priorities_survey_announcement").delete
  end

  def self.down
  end
end
