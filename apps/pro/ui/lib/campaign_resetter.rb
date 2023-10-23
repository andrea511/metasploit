class CampaignResetter
  def self.reset(campaign)
    SocialEngineering::Visit.email_in_campaign(campaign).delete_all
    SocialEngineering::Visit.web_in_campaign(campaign).delete_all
    SocialEngineering::PhishingResult.in_campaign(campaign).delete_all
    SocialEngineering::EmailOpening.in_campaign(campaign).delete_all
    SocialEngineering::EmailSend.in_campaign(campaign).delete_all
    campaign.reset
  end
end
