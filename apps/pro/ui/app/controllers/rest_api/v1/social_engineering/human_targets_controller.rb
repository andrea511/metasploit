class RestApi::V1::SocialEngineering::HumanTargetsController < RestApi::V1::BaseController
  has_scope :workspace_id

  def index
    @human_targets = apply_scopes(::SocialEngineering::HumanTarget).load
  end

  def show
    @human_target = ::SocialEngineering::HumanTarget.find(params[:id])
  end
end