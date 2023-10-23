class RestApi::V1::SocialEngineering::WebPagesController < RestApi::V1::BaseController
  has_scope :campaign_id

  def index
    @web_pages =  apply_scopes(::SocialEngineering::WebPage).load
  end

  def show
    @web_page = ::SocialEngineering::WebPage.find(params[:id])
  end
end