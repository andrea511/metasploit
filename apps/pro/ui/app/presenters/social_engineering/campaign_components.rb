module SocialEngineering
  class CampaignComponents < Struct.new(:campaign)
    def to_a
      campaign.all_components.collect(&:to_hash)
    end
  end
end