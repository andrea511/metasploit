class SocialEngineering::EmailsController < ApplicationController
  respond_to :js, :html
  layout nil

  before_action :load_workspace

  def assign_email(email)
    @email = email
    @email_path = determine_path_for(email)
  end

  def new
    campaign = find_campaign
    builder = EmailBuilder.new({}, campaign.id, campaign.uses_wizard?)
    email = builder.email
    assign_email(email)
    render :layout => false
  end
  
  def create
    creator = EmailCreator.new(self)
    creator.create_for(params[:campaign_id], social_engineering_email_params)
  end

  def create_email_succeeded(email)
    assign_email(email)
    render :json => ::SocialEngineering::CampaignSummary.new(@email.campaign).to_hash
  end

  def create_email_failed(email)
    assign_email(email)
    render :action => 'new', :layout => false, :status => :bad_request
  end

  def edit
    email = find_email
    assign_email(email)
  end

  def show
    email = find_email
    assign_email(email)
  end

  def update
    email = find_email
    assign_email(email)
    if params[:social_engineering_email] && params[:social_engineering_email]["file_generation_type"] == "user_supplied"
      cf = SocialEngineering::CampaignFile.find(params[:social_engineering_email]["user_supplied_file"])
      cf.attachable = email
      cf.save
    end

    if @email.update(social_engineering_email_params)
      render :json => ::SocialEngineering::CampaignSummary.new(@email.campaign).to_hash
    else
      render :action => 'edit', :status => :bad_request
    end
  end

  def destroy
    @email = find_email
    @email.destroy
    render :body => nil
  end

  def preview
    @email = find_email
    target = SocialEngineering::HumanTarget.dummy
    render :plain => @email.render_body_for_send(target, false)
  end

  def preview_pane
    @email = find_email
    render :layout => false
  end

  def custom_content_preview
    campaign = find_campaign
    template = SocialEngineering::EmailTemplate.find_by_id(params[:template_id])
    builder = EmailBuilder.new({
      :content => params[:content], 
      :origin_type => if template.present? then 'template' else 'custom' end
    }, campaign.id)
    target = SocialEngineering::HumanTarget.dummy
    email = builder.email
    email.email_template_id = if template.present? then template.id else nil end
    @html = email.render_body_for_send(target, false)
    render :layout => false
  end

  private

  def find_email
    the_id = params[:id].present? ? params[:id] : params[:email_id]
    SocialEngineering::Email.find(the_id)
  end

  def find_campaign
    SocialEngineering::Campaign.find(params[:campaign_id])
  end

  def determine_path_for(email)
    campaign = email.campaign
    workspace = campaign.workspace
    unless email.new_record?
      workspace_social_engineering_campaign_email_path(workspace, campaign, email)
    else
      workspace_social_engineering_campaign_emails_path(workspace, campaign)
    end
  end

  def social_engineering_email_params
    params.fetch(:social_engineering_email, {}).permit!
  end
end
