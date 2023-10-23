module SocialEngineering
  class PhishingResultsController < ApplicationController
    def index
      @campaign = Campaign.find(params[:campaign_id])
    end

    def show
      @phishing_result = PhishingResult.find(params[:id])
      @phishing_data = ActiveSupport::JSON.decode @phishing_result.data
    end
  end
end
