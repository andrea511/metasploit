class RestApi::V2::SocialEngineering::TargetListsController < RestApi::V2::BaseController
  has_scope :workspace_id
  has_scope :page, :default => 1
  has_scope :per, :as => :per_page, :default => 100

  def index
    @target_lists =  apply_scopes(::SocialEngineering::TargetList).load
  end

  def show
    @target_list = ::SocialEngineering::TargetList.find(params[:id])
  end
end