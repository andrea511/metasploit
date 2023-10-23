class SocialEngineering::TargetListsController < ApplicationController
  before_action :load_workspace
  before_action :load_target_list, :only => [:show, :export, :update, :remove_targets]

  layout false

  def index
    respond_to do |format|
      format.html do
        @target_lists = SocialEngineering::TargetList.where(:workspace_id => @workspace.id)
      end
      format.json do
        finder = ::TargetListsFinder.new(@workspace)
        render :json => DataTableQueryResponse.new(finder, params).to_json
      end
    end
  end

  def new
    @target_list = SocialEngineering::TargetList.new
  end

  def create
    @target_list = SocialEngineering::TargetList.new(target_list_params[:social_engineering_target_list])
    import_file = import_file_from_params
    @target_list.user = current_user
    @target_list.workspace = @workspace
    @target_list.import_file = import_file
    saved = @target_list.save
    if saved && !@target_list.errors.any?
      flash.now[:notice] = "Target List '#{@target_list.name}' successfully created."
      @target_list.reload
      render :partial => 'create_success'
    else
      if saved
        human_ids = SocialEngineering::TargetList.joins(:human_targets).select('se_human_targets.id').where(id: @target_list.id).map &:id
        @target_list.destroy
        SocialEngineering::HumanTarget.destroy_orphans(human_ids)
      end
      @prev_targets = @target_list.quick_add_targets
      render :new
    end
  end

  def show
  end

  def update
    @target_list.update target_list_params[:social_engineering_target_list]
    @prev_targets = @target_list.quick_add_targets if @target_list.errors.any?
    render :show
  end

  def export
  end

  def destroy
    attack_ids = target_list_params[:target_list_ids] || []

    if attack_ids.empty?
      render :json => {:error => "No Target Lists selected to delete"}, :status => :bad_request
    else
      begin
        human_ids = SocialEngineering::TargetList.joins(:human_targets).select('se_human_targets.id').where(id: attack_ids).map &:id
        SocialEngineering::TargetList.destroy(attack_ids)
        SocialEngineering::HumanTarget.destroy_orphans(human_ids)
        head :ok
      rescue ActiveRecord::DeleteRestrictionError
        emails = SocialEngineering::Email.where("target_list_id IN (?)", attack_ids)
        campaigns = emails.collect(&:campaign).uniq
        campaigns_str = campaigns.collect{ |camp| "\"#{camp.name}\"" }.join(", ")
        error_str = "is use in by the #{'campaign'.pluralize(campaigns.size)} #{campaigns_str}"
        render :json => {:error => "Unable to delete Target List because it #{error_str}."}, :status => :bad_request
      end
    end
  end

  private

    # To facilitate specs:
  def import_file_from_params
    if target_list_params[:social_engineering_target_list][:import_file].present?
      target_list_params[:social_engineering_target_list][:import_file].tempfile
    else
      nil
    end
  end

  def load_target_list
    tid = target_list_params[:id] || target_list_params[:target_list_id]
    @target_list = SocialEngineering::TargetList.where(:workspace_id => @workspace.id, :id => tid).first
  end

  def target_list_params

    params.permit!
  end
end
