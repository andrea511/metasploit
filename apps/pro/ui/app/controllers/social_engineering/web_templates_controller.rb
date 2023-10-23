class SocialEngineering::WebTemplatesController < ApplicationController
  include SocialEngineering::CloneProxy
  before_action :load_workspace
  before_action :load_web_template, :only => [:edit, :update]
  before_action :load_web_templates, :only => :index

  layout false

  def index
    respond_to do |format|
      format.html
      format.json do
        # so we don't pass the entire content string in the #index call
        finder = ::TemplatesFinder.new(@workspace, SocialEngineering::WebTemplate)
        render :json => DataTableQueryResponse.new(finder, params).to_json
      end
    end
  end

  def destroy
    template_ids = params[:web_template_ids] || []
    if template_ids.empty?
      render :json => {:error => "No web templates selected to delete"}, :status => :bad_request
    else
      begin
        SocialEngineering::WebTemplate.destroy(template_ids)
        head :ok
      rescue ActiveRecord::DeleteRestrictionError
        pages = SocialEngineering::WebPage.where("web_template_id IN (?)", template_ids)
        campaigns = pages.collect(&:campaign).uniq
        campaigns_str = campaigns.collect{ |camp| "\"#{camp.name}\"" }.join(", ")
        error_str = "is use in by the #{'campaign'.pluralize(campaigns.size)} #{campaigns_str}"
        render :json => {:error => "Unable to delete Web Template because it #{error_str}."}, :status => :bad_request
      end
    end
  end

  def new
    @web_template = SocialEngineering::WebTemplate.new
    @web_template.origin_type ||= SocialEngineering::WebTemplate::ORIGIN_TYPES.first
  end

  def create
    @web_template = SocialEngineering::WebTemplate.new(
      templates_params
    )
    @web_template.workspace = @workspace
    @web_template.user = current_user

    if @web_template.save
      head :ok
    else
      render :new, :status => :bad_request
    end
  end

  def edit
  end

  def update
    @web_template.update(templates_params)
    if @web_template.save
      head :ok
    else
      render :edit, :status => :bad_request
    end
  end

  private

  def load_web_templates
    @web_templates = SocialEngineering::WebTemplate.where(workspace_id: @workspace.id)
  end

  def load_web_template
    @web_template = SocialEngineering::WebTemplate.find(params[:id])
  end

  def templates_params
    params.fetch(:social_engineering_web_template, {}).permit!
  end
end
