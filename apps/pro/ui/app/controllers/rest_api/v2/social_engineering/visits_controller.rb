class RestApi::V2::SocialEngineering::VisitsController < RestApi::V2::BaseController
  has_scope :campaign_id

  def index
    @visits = apply_scopes(::SocialEngineering::Visit).load
  end

  def show
    @visit = ::SocialEngineering::Visit.find(params[:id])
  end

end
