class RestApi::V2::SocialEngineering::PhishingResultsController < RestApi::V2::BaseController
  has_scope :campaign_id

  # Return all results for a Campaign
  def index
    @phishing_results = apply_scopes(::SocialEngineering::PhishingResult).load
  end

  def show
    @phishing_result = ::SocialEngineering::PhishingResult.find(params[:id])
  end

end