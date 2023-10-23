class RestApi::V1::SocialEngineering::EmailsController < RestApi::V1::BaseController
  has_scope :campaign_id

  def index
    @emails = apply_scopes(::SocialEngineering::Email).load
  end

  def show
    @email = ::SocialEngineering::Email.find(params[:id])
  end

end
