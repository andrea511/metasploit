module SocialEngineering
  class ConfigurableCampaignChecker
    def self.configured?(campaign)
      return false if empty?(campaign)
      only_usb?(campaign) || 
        ( 
          configured_web_campaign?(campaign) && 
          configured_email_campaign?(campaign) &&
          configured_phishing_campaign?(campaign)
        )
    end

    private

    def self.empty?(campaign)
      campaign.portable_files.blank?  &&
      campaign.web_pages.blank? &&
      campaign.emails.blank?
    end

    def self.only_usb?(campaign)
      campaign.usb_campaign?  && 
      !campaign.web_campaign? &&
      !campaign.email_campaign?
    end
 
    def self.configured_web_campaign?(campaign)
      if campaign.web_campaign?
        campaign.web_pages.all?(&:configured?) && campaign.web_host.present? &&
          campaign.web_port.present?
      else
        true
      end
    end

    def self.configured_email_campaign?(campaign)
      if campaign.email_campaign?
        campaign.smtp_configured?
      else
        true
      end
    end

    def self.configured_phishing_campaign?(campaign)
      if campaign.uses_wizard?
        !campaign.web_pages.empty? && !campaign.emails.empty?
      else
        true
      end
    end
  end
end
