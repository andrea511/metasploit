module SocialEngineering
  class CampaignConfiguration < Struct.new(:campaign)
    def to_hash
      {
        web_config: {
          configured: campaign.web_configured?
        },
        smtp_config: {
          configured: campaign.smtp_configured?
        }
      }
    end
  end
end