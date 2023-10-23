class SocialEngineering::CampaignsController < ApplicationController
  before_action :load_workspace, :only => [:index]
  before_action :my_load_workspace, :except => [:index]
  before_action :check_license
  before_action :redirect_if_not_licensed, :except => [:index]

  respond_to :html, :js

  def index

    # @licensed = License.get.supports_campaigns?

    @campaign = SocialEngineering::Campaign.new
    @campaign.config_type = SocialEngineering::Campaign::CAMPAIGN_CONFIG_TYPES.first

    campaigns = SocialEngineering::Campaign.where(:workspace_id => @workspace.id).order('created_at DESC')
    @summaries = campaigns.map { |c| SocialEngineering::CampaignSummary.new(c).to_hash }
    @num_campaigns = campaigns.count

    respond_to do |format|
      format.html
      format.json do
        render :json => @summaries.to_json
      end
      format.js do
        render :json => @summaries.to_json
      end
    end
  end

  def new
    @campaign = SocialEngineering::Campaign.new
  end

  def edit
    @campaign = find_campaign
  end

  def create
    @campaign              = SocialEngineering::Campaign.new(campaign_params)

    # Set protected attributes directly
    @campaign.user         = current_user
    @campaign.web_bap_port = SocialEngineering::Campaign::DEFAULT_WEB_BAP_PORT
    @campaign.web_host     = Rex::Socket.source_address()
    @campaign.web_port     = SocialEngineering::Campaign::DEFAULT_WEB_PORT
    @campaign.workspace    = @workspace

    add_smtp_settings
    respond_to do |format|
      if @campaign.save
        format.js { render :json => @campaign.as_json(:only => [:id, :name]) }
      else
        format.js { render :json => {error: @campaign.errors.as_json}, :status => :bad_request }
      end
    end
  end

  def update
    @campaign = find_campaign

    # delete ALL components if we change the config_type
    params[:social_engineering_campaign] ||= {}
    if params[:social_engineering_campaign][:config_type].present?
      if @campaign.config_type != params[:social_engineering_campaign][:config_type]
        @campaign.all_components.each(&:destroy)
      end
    end

    if @campaign.update(campaign_params)
      respond_to do |format|
        format.html {
          flash[:notice] = "Campaign updated"
          redirect_to workspace_social_engineering_campaign_path
        }
        format.json {
          render :json => {:success => true}
        }
      end
    else
      respond_to do |format|
        format.html {
          render :action => 'edit'
        }
        format.json {
          err_msg = []
          @campaign.errors.each { |k, v| err_msg << "#{k} #{v}" }
          render :json => {:success => false, :message => 'Error: '+err_msg.join(',<br />')}
        }
      end
    end
  end

  def show
    @campaign = find_campaign
    render :json => ::SocialEngineering::CampaignSummary.new(@campaign).to_json
  end

  def destroy
    find_campaign.destroy
    render :json => {:success => true}
  end

  def execute
    campaign = find_campaign
    executor = ::CampaignExecutor.new(self)
    executor.execute(campaign, current_user)
  end

  def execute_campaign_successful(campaign)
    render :json => SocialEngineering::CampaignSummary.new(campaign).to_json
  end

  def start_limit_exceeded(limit)
    err_msg = "Cannot run more than #{limit} #{ 'campaign'.pluralize(limit) } at a time."
    render :json => {error: err_msg}.to_json, :status => :bad_request
  end

  def campaign_not_executable(campaign)
    render :json => SocialEngineering::CampaignSummary.new(campaign).to_json
  end

  def check_for_configuration_errors
    campaign          = find_campaign
    status, error_msg = check_ports

    if status == :error
      render :json => {error: error_msg}.to_json, :status => :bad_request
      return
    end
    status, error_msg = check_portable_files
    if status == :error
      render :json => {error: error_msg}.to_json, :status => :bad_request
      return
    end
    limit    = ::CampaignExecutor::START_LIMIT
    executor = ::CampaignExecutor.new(self)
    if executor.start_limit_exceeded?(campaign)
      # find running campaign
      running_campaign = SocialEngineering::Campaign.where(
        "state IN (?)", ['running', 'preparing']
      ).first
      err_msg          = "Campaign '#{running_campaign.name}' in project '#{running_campaign.workspace.name}' " +
        "launched by user '#{running_campaign.started_by_user.username}' is still running. \n\n" +
        "Cannot run more than #{limit} #{ 'campaign'.pluralize(limit) } at a time."
      render :json => {error: err_msg}.to_json, :status => :bad_request
    else
      head :ok
    end
  end

  def reset
    @campaign = find_campaign
    CampaignResetter.reset(@campaign)
    head :ok
  end

  def sent_emails
    campaign = find_campaign
    finder   = ::SentEmailsFinder.new(campaign)
    render_results_from(finder)
  end

  def opened_emails
    campaign = find_campaign
    finder   = ::OpenedEmailsFinder.new(campaign)
    render_results_from(finder)
  end

  def opened_sessions
    campaign = find_campaign
    finder   = ::OpenedSessionsFinder.new(campaign)
    render_results_from(finder)
  end

  def submitted_forms
    campaign = find_campaign
    finder   = ::SubmittedFormsFinder.new(campaign)
    render_results_from(finder)
  end

  def links_clicked
    campaign = find_campaign
    finder   = ::ClickedLinkTargetsFinder.new(campaign)
    render_results_from(finder)
  end

  def render_results_from(finder)
    data_table = DataTableQueryResponse.new(finder, params)
    if params[:format] == 'csv'
      render :csv => data_table.to_csv
    else
      render :json => data_table.to_json
    end
  end

  def logged_in
    # user will already get a 403 if they aren't authed
    head :ok
  end

  def to_task
    campaign = find_campaign
    task     = Mdm::Task.find_campaign_tasks(campaign).sort {|a,b| a.created_at <=> b.created_at}.last
    if task.present?
      render json: {id: task.id}
    else
      # tell browser to try again in one second
      head :error
    end
  end

  protected

  def my_load_workspace
    if params[:workspace_id]
      load_workspace
    else
      @workspace = @campaign.workspace
    end
  end

  def find_campaign
    SocialEngineering::Campaign.find(params[:id])
  end

  def generate_exe
    generate_task = GenerateExeTask.new({
                                          :username  => current_user.username,
                                          :workspace => @workspace,
                                          :campaign  => @campaign,
                                          :lhost     => @campaign.payload_lhost,
                                          :lport     => @campaign.exe_lport,
                                          :filename  => @campaign.exe_name,
                                          :ptype     => @campaign.payload_type
                                        })
    task          = generate_task.start
    if not task
      @campaign.status = :error
      @campaign.error  = generate_task.error
    else
      @campaign.prefs[:task] = task.id
    end
  end

  def check_license
    @licensed = License.get.supports_campaigns?
  end

  def redirect_if_not_licensed
    unless @licensed
      render :plain => "Unlicensed", :layout => "forbidden", :status => 403 # Forbidden
    end
  end

  def check_portable_files
    campaign = find_campaign
    campaign.portable_files.each do |pf|
      if pf.prefs['PAYLOAD'].blank?
        return [:error, 'Portable File has not finished generating']
      end
    end
  end

  def check_ports
    campaign = find_campaign
    web_port = campaign.web_port
    bap_port = campaign.web_bap_port
    mapper   = Metasploit::Pro::LportMapper.new
    if campaign.web_pages.any?
      unless mapper.lport_available?(web_port)
        return [:error, "Web Port is unavailable"]
      end
    end

    if campaign.bap_campaign?
      unless mapper.lport_available?(bap_port)
        return [:error, "BAP Port is unavailable"]
      end
    end

    campaign.portable_files.each do |pf|
      lp = pf.lport
      unless mapper.lport_available?(lp)
        return [:error, "Port is unavailable for Portable File: #{pf.name} due to active sessions. Please choose a different port and try starting the campaign again."]
      end
      if lp == web_port
        return [:error, "Web Port Conflicts with LPORT for Portable File #{pf.name}"]
      end
      if campaign.bap_campaign?
        if lp == bap_port
          return [:error, "BAP Port Conflicts with LPORT for Portable File #{pf.name}"]
        end
      end
    end
    return [:ok, '']
  end

  def add_smtp_settings
    settings = current_profile.smtp_settings
    @campaign.smtp_host        = settings.address
    @campaign.smtp_port        = settings.port.to_i
    @campaign.smtp_username    = settings.username
    @campaign.smtp_password    = settings.password
    @campaign.smtp_auth        = settings.authentication.to_s
    @campaign.smtp_domain      = settings.domain
    @campaign.smtp_ssl         = settings.ssl
    @campaign.smtp_batch_size  = SocialEngineering::SmtpServerConfigInterface::SMTP_BATCH_SIZE
    @campaign.smtp_batch_delay = SocialEngineering::SmtpServerConfigInterface::SMTP_BATCH_DELAY
  end

  private

  def campaign_params
    params.fetch(:social_engineering_campaign, {}).permit!
  end
end


