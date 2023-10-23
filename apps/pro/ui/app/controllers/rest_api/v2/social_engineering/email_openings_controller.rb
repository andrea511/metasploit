class RestApi::V2::SocialEngineering::EmailOpeningsController < RestApi::V2::BaseController
  has_scope :campaign_id

  def index
    @email_openings = apply_scopes(::SocialEngineering::EmailOpening).load
  end

  def show
    @email_opening = ::SocialEngineering::EmailOpening.find(params[:id])
  end

end
