class SocialEngineering::CampaignsCleaner
  def self.cleanup!
    if SocialEngineering::Campaign.table_exists?
      SocialEngineering::Campaign.where("state = 'running' or state ='preparing'").each do |campaign|
        campaign.interrupt
      end
    end
  end
end
