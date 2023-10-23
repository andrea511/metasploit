class SocialEngineering::WebPagesController < ApplicationController
  include SocialEngineering::CloneProxy
  respond_to :js, :html

  before_action :sanitize_lhost, :only => [:new, :create, :update ]
  before_action :load_workspace
  before_action :assign_web_page, :only => [:edit, :preview, :preview_pane]

  # Explicitly turn CSP OFF, so that web page previews can link to external
  # images and stylesheets as the user expects.
  # Note that the iframes have HTML5 sandboxing, so running any javascripts
  # is impossible in the first place.

  def new
    # TODO: A before_filter might be cleaner here
    use_secure_headers_override(:phishing)
    # we should refactor this into a webpage_builder, a la emails
    campaign = find_campaign
    @web_page = campaign.web_pages.build() 
    @web_page.name = 'Web Page' # default value
    @web_page.name = params[:init_name] unless params[:init_name].blank?
    if campaign.uses_wizard?
      if @web_page.name == SocialEngineering::WebPage::PHISHING_LANDING_PAGE_DEFAULT_NAME
        # landing page defaults
        @web_page.content = SocialEngineering::WebPage::DEFAULT_PHISHING_CONTENT
        @web_page.save_form_data = true
        @web_page.phishing_redirect_origin = 'phishing_wizard_redirect_page'
        @web_page.attack_type = 'phishing'
      else
        # redirect page defaults
        @web_page.content = SocialEngineering::WebPage::DEFAULT_REDIRECT_CONTENT
        @web_page.attack_type = 'none'
      end
    else
      @web_page.content = SocialEngineering::WebPage::DEFAULT_CONTENT
    end
    @web_page.origin_type ||= SocialEngineering::WebPage::ORIGIN_TYPES.first
    @web_page.phishing_redirect_origin ||= SocialEngineering::WebPage::PHISHING_REDIRECT_ORIGINS.first
    @web_page.path ||= create_random_web_page_path
    
    assign_page_title

    assign_web_page_path
  end

  def create
    use_secure_headers_override(:phishing)
    campaign = find_campaign
    @web_page = campaign.web_pages.build(social_engineering_web_page_params)
    if @web_page.save
      if @web_page.attack_type == 'phishing'
        @web_page.update(:original_content => @web_page.content)
      end
      assign_web_page_path
      render :json => ::SocialEngineering::CampaignSummary.new(@web_page.campaign).to_hash
    else
      assign_web_page_path
      assign_page_title
      render :new, :status => :bad_request
    end
  end

  def show
    use_secure_headers_override(:phishing)
    @web_page = SocialEngineering::WebPage.find(params[:id])
    if @web_page.attack_type == 'phishing' and not @web_page.original_content.blank?
      @web_page.content = @web_page.original_content
    end
    assign_web_page_path
  end

  def edit
    use_secure_headers_override(:phishing)
    if @web_page.attack_type == 'phishing' and not @web_page.original_content.blank?
      @web_page.content = @web_page.original_content
    end
    assign_web_page_path
    assign_page_title
  end

  def destroy
    use_secure_headers_override(:phishing)
    web_page = SocialEngineering::WebPage.find(params[:id])
    web_page.destroy
    render :body => nil
  end

  def update
    use_secure_headers_override(:phishing)
    @web_page = SocialEngineering::WebPage.find(params[:id])
    assign_web_page_path
    cleanup_files
    # checkbox not present in post request if unchecked, add it in heres
    params[:social_engineering_web_page] = {:online => false}.merge social_engineering_web_page_params
    if @web_page.update(social_engineering_web_page_params)
      if @web_page.attack_type == 'phishing'
        @web_page.update(:original_content => @web_page.content)
      end
      render :json => ::SocialEngineering::CampaignSummary.new(@web_page.campaign).to_hash
    else
      assign_page_title
      render :action => :edit, :status => :bad_request
    end
  end

  def preview
    use_secure_headers_override(:phishing)
    @content = @web_page.render_page_in_template
    # add zooming
    add_squeeze_frame_js_to_preview
    render :layout => false
  end

  def preview_pane
    use_secure_headers_override(:phishing)
    render :layout => false
  end

  def custom_content_preview
    use_secure_headers_override(:phishing)
    campaign = find_campaign
    template = SocialEngineering::WebTemplate.find_by_id(params[:template_id])
    @web_page = SocialEngineering::WebPage.new
    @web_page.campaign = campaign
    @web_page.template = template
    @web_page.content = params[:content].reverse || ""
    @content = @web_page.render_page_in_template
    add_squeeze_frame_js_to_preview
    render :preview, :layout => false
  end

  private

  def assign_web_page
    @web_page = SocialEngineering::WebPage.find(params[:id] || params[:web_page_id])
  end

  def assign_web_page_path
    @web_page_path = determine_web_page_path(@web_page)
  end

  def determine_web_page_path(web_page)
    campaign = web_page.campaign
    workspace = campaign.workspace
    if web_page.persisted?
      workspace_social_engineering_campaign_web_page_path(workspace, campaign, web_page)
    else
      workspace_social_engineering_campaign_web_pages_path(workspace, campaign)
    end
  end

  def cleanup_files
    @web_page.files.clear
    unless file_attack?
      params[:social_engineering_web_page].delete(:file_ids)   
    end
  end

  def file_attack?
    params[:social_engineering_web_page][:attack_type] == 'file'
  end

  def sanitize_lhost
    if params[:social_engineering_web_page].present?  && params[:social_engineering_web_page][:exploit_module_config].present?
      params[:social_engineering_web_page][:exploit_module_config][:payload_lhost] = (params[:social_engineering_web_page][:exploit_module_config][:payload_lhost]=='localhost') ? '127.0.0.0' : params[:social_engineering_web_page][:exploit_module_config][:payload_lhost]
    end
  end


  def assign_page_title
    campaign = find_campaign
    if campaign.uses_wizard?
      if @web_page.name == SocialEngineering::WebPage::PHISHING_REDIRECT_PAGE_DEFAULT_NAME
        @title = 'Configure Redirect Page'
        @pages = ['Configure Redirect Page Settings', 'Create Redirect Page Content']
      elsif @web_page.name == SocialEngineering::WebPage::PHISHING_LANDING_PAGE_DEFAULT_NAME
        @title = 'Configure Landing Page'
        @pages = ['Configure Landing Page Settings', 'Create Landing Page Content']
      end
    else
      @title = SocialEngineering::WebPage::WEB_PAGE_TITLE
      @pages = ['Configure Web Page Settings', 'Create Web Page Content']
    end
  end

  def find_campaign
    @campaign ||= SocialEngineering::Campaign.find(params[:campaign_id])
  end

  def create_random_web_page_path
    words = %W{red amazing orange super yellow awesome green secure blue epic indigo violet gray pink purple}
    words[ rand(words.length) ] + rand(100).to_s
  end

  def add_squeeze_frame_js_to_preview
    @extra_content = "<script type='text/javascript' src='#{root_url}assets/squeezeFrame.js'></script>"
  end

  def social_engineering_web_page_params
    params.fetch(:social_engineering_web_page, {}).permit!
  end
end
