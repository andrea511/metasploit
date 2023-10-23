class RestApi::V2::SocialEngineering::CampaignsController < RestApi::V2::BaseController
  has_scope :workspace_id

  # Assumes the user wants ALL SocialEngineering campaigns
  # across all Workspaces
  def index
    @campaigns = apply_scopes(::SocialEngineering::Campaign).load
  end

  def show
    # Eager-load associations
    results = ::SocialEngineering::Campaign.where(id: params[:id]).includes(:web_pages, :emails)
    if results.present?
      @campaign = results.first
    else
      raise ActiveRecord::RecordNotFound
    end
  end

end