class SocialEngineering::VisitsController < ApplicationController
  before_action :find_campaign
  before_action :load_workspace

  def index
    @visits = @campaign.visits_with_targets
  end

  private

  def find_campaign
    @campaign = SocialEngineering::Campaign.find(params[:campaign_id])
  end

end
