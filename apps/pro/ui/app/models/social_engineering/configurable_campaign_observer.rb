module SocialEngineering
  class ConfigurableCampaignObserver < ActiveRecord::Observer
    observe SocialEngineering::Email,
            SocialEngineering::WebPage,
            SocialEngineering::PortableFile,
            SocialEngineering::Campaign

    def after_create(record)
      if component?(record)
        record.campaign.configure!
      end
    end

    def after_save(record)
      if component?(record)
        record.campaign.configure!
      else
        record.configure!
      end
    end

    def after_destroy(record)
      if component?(record)
        record.campaign.configure!
      end
    end
    
    private

    def component?(record)
      record.respond_to?(:campaign)  
    end
  end
end
