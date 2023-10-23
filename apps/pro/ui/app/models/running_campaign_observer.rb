class RunningCampaignObserver < ActiveRecord::Observer
  observe SocialEngineering::Email,
          SocialEngineering::WebPage,
          SocialEngineering::PortableFile

  def before_save(record)
    if running_campaign?(record)
      record.errors.add(:base, 'Cannot make changes while a campaign is running')
      return false
    end
  end

  private

  def running_campaign?(record)
    record.campaign.running?
  end
end
