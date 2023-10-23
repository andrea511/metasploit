class SocialEngineering::PortableFilesController < ApplicationController
  respond_to :js

  def new
    @portable_file = SocialEngineering::PortableFile.new(
      :file_generation_type => "exe_agent"
    )
    @portable_file.name ||= "USB Key"
    @portable_file.file_name = 'ClickMe.exe'
    @portable_file.lport = 1024
    @portable_file.payload_type = "reverse_tcp"
    @portable_file.campaign = find_campaign
    @portable_file.lhost = Rex::Socket.source_address('50.50.50.50')
    assign_portable_file_path
  end

  def create
    pf_opts = file_params
    @portable_file = SocialEngineering::PortableFile.new(
      :name => pf_opts[:name],
      :file_name => pf_opts[:file_name],
      :lport => pf_opts[:lport].to_i,
      :payload_type => pf_opts[:payload_type],
      :file_generation_type => pf_opts[:file_generation_type],
      :exploit_module_config => pf_opts[:exploit_module_config],
      :exploit_module_path => pf_opts[:exploit_module_path],
      :lhost => pf_opts[:lhost],
      :dynamic_stagers => pf_opts[:dynamic_stagers])
    @portable_file.campaign = find_campaign
    if @portable_file.save
      generate_file
      assign_portable_file_path
      render :json => ::SocialEngineering::CampaignSummary.new(@portable_file.campaign).to_hash
    else
      assign_portable_file_path
      render :action => "new", :status => :bad_request
    end
  end

  def edit
    @portable_file = find_portable_file
    assign_portable_file_path
  end

  def show
    @portable_file = find_portable_file
    assign_portable_file_path
  end

  
  def update
    @portable_file = find_portable_file
    pf_params = file_params.merge({:lport => file_params[:lport].to_i})
    assign_portable_file_path
    if @portable_file.update(pf_params)
      begin
        # to ensure a correct download link, we need to delete
        # the campaign files from the database, so that the
        # UI poller can pick up the correct link
        @portable_file.files.each(&:destroy)
      rescue
        # workaround
        # there is a callback to delete the campaign file
        # from the file system, but it fails because thin
        # is not running as root.  It's sufficient to delete
        # the database entry and not delete the file from
        # the file system for this to work. there is no risk
        # of leaving the old file on the file system
      end
      generate_file
      render :json => ::SocialEngineering::CampaignSummary.new(@portable_file.campaign).to_hash
    else
      render :action => 'edit', :status => :bad_request
    end
  end

  def destroy
    @portable_file = find_portable_file
    @portable_file.destroy
    render :body => nil
  end 

  private

  def assign_portable_file_path
    @portable_file_path = determine_path_for(@portable_file)
  end

  def determine_path_for(portable_file)
    campaign = portable_file.campaign
    workspace = campaign.workspace
    if portable_file.persisted?
      workspace_social_engineering_campaign_portable_file_path(workspace, campaign, portable_file)
    else
      workspace_social_engineering_campaign_portable_files_path(workspace, campaign)
    end
  end

  def find_portable_file
    the_id = params[:id].present? ? params[:id] : params[:portable_file_id]
    SocialEngineering::PortableFile.find(the_id)
  end

  def find_campaign
    SocialEngineering::Campaign.find(params[:campaign_id])
  end

	def generate_file
		generate_task = GeneratePortableFile.new({
			:portable_file => @portable_file,
      :workspace => @portable_file.campaign.workspace
		})
		generate_task.start
  end

  def file_params
    params.fetch(:social_engineering_portable_file, {}).permit!
  end
end
