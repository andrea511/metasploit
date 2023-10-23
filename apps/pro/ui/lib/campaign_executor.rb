class CampaignExecutor < Struct.new(:listener)
  START_LIMIT = 1

  def execute(campaign, current_user)
    if start_limit_exceeded?(campaign)
      listener.start_limit_exceeded(START_LIMIT)
    else
      if campaign.executable?
        campaign.execute!(current_user)
        listener.execute_campaign_successful(campaign)
      else
        listener.campaign_not_executable(campaign)
      end
    end
  end

  def start_limit_exceeded?(campaign)
    return false if campaign.is_running?
    SocialEngineering::Campaign.where(
      "state IN (?)", ['running', 'preparing']
    ).count >= START_LIMIT
  end
end
