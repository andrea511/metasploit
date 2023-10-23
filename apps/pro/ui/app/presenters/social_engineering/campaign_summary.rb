module SocialEngineering
  class CampaignSummary < Struct.new(:campaign)
    def facts_data
      CampaignFacts.new(campaign).to_hash
    end

    def details_data
      CampaignDetails.new(campaign).to_hash
    end

    def components_data
      CampaignComponents.new(campaign).to_a
    end

    def configuration_data
      CampaignConfiguration.new(campaign).to_hash
    end

    def as_json(options={})
      to_hash
    end

    def to_hash
      campaign.as_json(
        :only => [:name, :id, :config_type,
                  :notification_enabled, :notification_email_address, :notification_email_message,
                  :notification_email_subject]
      ).merge({
        :campaign_configuration => configuration_data,
        :campaign_facts         => facts_data,
        :campaign_details       => details_data,
        :campaign_components    => components_data,
      })
    end
  end
end
