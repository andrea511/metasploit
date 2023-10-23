class SocialEngineering::EmailTemplatesController < ApplicationController
  before_action :load_workspace
  before_action :load_email_template, :only => [:edit, :update]

  layout false

  def index
    respond_to do |format|
      format.html do
        load_email_templates
      end
      format.json do
        # so we don't pass the entire content string in the #index call
        finder = ::TemplatesFinder.new(@workspace, SocialEngineering::EmailTemplate)
        render :json => DataTableQueryResponse.new(finder, params).to_json
      end
    end
  end

  def destroy
    template_ids = params[:email_template_ids] || []
    if template_ids.empty?
      render :json => {:error => "No email templates selected to delete"}, :status => :bad_request
    else
      begin
        SocialEngineering::EmailTemplate.destroy(template_ids)
        head :ok
      rescue ActiveRecord::DeleteRestrictionError
        emails = SocialEngineering::Email.where("email_template_id IN (?)", template_ids)
        campaigns = emails.collect(&:campaign).uniq
        campaigns_str = campaigns.collect{ |camp| "\"#{camp.name}\"" }.join(", ")
        error_str = "is use in by the #{'campaign'.pluralize(campaigns.size)} #{campaigns_str}"
        render :json => {:error => "Unable to delete Email Template because it #{error_str}."}, :status => :bad_request
      end
    end
  end

  def new
    @email_template = SocialEngineering::EmailTemplate.new
  end

  def create
    @email_template = SocialEngineering::EmailTemplate.new(
      template_params
    )
    @email_template.workspace = @workspace
    @email_template.user = current_user

    if @email_template.save
      head :ok
    else
      render :new, :status => :bad_request
    end
  end

  def edit
  end

  def update
    @email_template.update(template_params)
    if @email_template.save
      head :ok
    else
      render :edit, :status => :bad_request
    end
  end

  private

  def load_email_templates
    @email_templates = SocialEngineering::EmailTemplate.where(workspace_id: @workspace.id)
  end

  def load_email_template
    @email_template = SocialEngineering::EmailTemplate.find(params[:id])
  end

  def template_params
    params.require(:social_engineering_email_template).permit!
  end
end
