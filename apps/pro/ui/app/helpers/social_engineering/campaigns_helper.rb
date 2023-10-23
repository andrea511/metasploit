module SocialEngineering
  module CampaignsHelper
    def campaign_status_for(campaign = @campaign)
      presenter = CampaignStatus.new(campaign)
      if block_given?
        yield presenter
      else
        presenter
      end
    end

    def component_prefix(component)
      class_name = component.class.name.gsub(/.*::/, '').underscore.humanize
      "#{class_name}: "
    end
  end
end
