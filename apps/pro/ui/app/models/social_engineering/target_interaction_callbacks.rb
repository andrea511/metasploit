# Included into each kind of model that represents an interaction by a HumanTarget -
# SocialEngineering::PhishingResult, SocialEngineering::Visit, SocialEngineering::EmailOpening
module SocialEngineering::TargetInteractionCallbacks
  def self.included(base)
    base.send(:after_create, :update_campaign_last_target_interacted_at)
  end

  # @return[void] Update parent Campaign's target interaction timestamp
  def update_campaign_last_target_interacted_at
    parent = case self
               when SocialEngineering::PhishingResult
                 :web_page
               when SocialEngineering::Visit
                 :email
               when SocialEngineering::EmailOpening
                 :email
             end
    campaign = self.send(parent).campaign
    campaign.last_target_interaction_at = self.created_at
    campaign.save
  end

end