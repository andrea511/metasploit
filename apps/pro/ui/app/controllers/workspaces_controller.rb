class WorkspacesController < ApplicationController
  include AnalysisSearchMethods
  include Metasploit::Pro::AttrAccessor::Boolean
  include Metasploit::Pro::AddressUtils

  before_action :require_membership, :only => [:show]
  before_action :require_manageability, :only => [:edit, :update]

  require 'shellwords'

  def index
    @workspaces = if (not current_user.admin) and License.get.multi_user?
      current_user.accessible_workspaces.sort_by(&:updated_at).reverse
    else
      Mdm::Workspace.order('updated_at DESC')
    end
    @feed_serial   = License.get.product_serial
    @feed_version  = License.get.product_version
    @feed_revision = License.get.product_revision
    @feed_edition  = License.get.edition.downcase
    @feed_ts       = Time.now.to_i.to_s
    @feed_orig_version = License.get.product_orig_version
    @supports_quick_start_menu = License.get.supports_quick_start_and_global_tools?
    @enable_news_feed = set_default_boolean(current_profile.settings['enable_news_feed'], true)
  end

  def new
    @workspace = Mdm::Workspace.new(
      :boundary => default_ip_range,
      :users => Mdm::User.all,
      :owner => current_user
    )
  end

  def create
    params[:workspace][:user_ids] ||= []
    @workspace = Mdm::Workspace.new(workspace_params)
    if @workspace.save
      AuditLogger.user("#{ip_user} - Project #{@workspace.name} created with access granted to #{users_with_access}")
      respond_to do |format|
        format.html { redirect_to workspace_path(@workspace) }
        format.json do
          render :json => { :path => workspace_path(@workspace) }
        end
      end
    else
      respond_to do |format|
        format.html { render :action => 'new' }
        format.json do
          render :json   => { :errors => @workspace.errors },
                 :status => :bad_request
        end
      end
    end
  end

  def edit
    @workspace = Mdm::Workspace.find(params[:id])
  end

  def update
    params = workspace_params
    params["user_ids"] ||= []

    # add admins and project owner to user_ids
    params["user_ids"].append(@workspace.owner.id)

    admin_ids = Mdm::User.where(admin: [true]).pluck(:id)
    params["user_ids"].push(*admin_ids)

    old_user_set = users_with_access
    if @workspace.update(params)
      log_changed_access(old_user_set, users_with_access)
      flash[:notice] = "Project '#{@workspace.name}' updated"
      redirect_to workspaces_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    workspaces = if params[:id]
      [ Mdm::Workspace.find(params[:id]) ]
    elsif params[:workspace_ids]
      Mdm::Workspace.find(params[:workspace_ids])
    else
      []
    end

    workspaces.each do |workspace|
      unless workspace.manageable_by?(current_user)
        render(:text => "You are not the owner of this project", :layout => "forbidden", :status => 403) and return
      end

      workspace.tasks.each { |t| t.rpc_stop }
      workspace.sessions.each { |s| s.stop rescue nil }
      workspace.destroy
    end

    if workspaces.empty?
      flash[:error] = "No Projects selected to remove"
    else
      flash[:notice] = view_context.pluralize(workspaces.length, "Project") + " removed"
    end

    respond_to do |format|
      format.html { redirect_to workspaces_url }
      format.xml  { head :ok }
    end
  end

  def show
    @workspace = Mdm::Workspace.find(params[:id])
    @tasks = @workspace.tasks.running
    @disco_running       = @tasks.any? { |t| t.discovery? }
    @penetration_running = @tasks.any? { |t| t.penetration? }
    @collection_running  = @tasks.any? { |t| t.collection? }
    @stats = @workspace.stats

    respond_to do |format|
      format.html
    end
  end

  def search
    @workspace = Mdm::Workspace.find(params[:workspace_id]) if params[:workspace_id]
    @search = params[:search]
    @search_terms = ::Shellwords.shellwords(@search) rescue @search.split(/\s+/)
    @search_terms.reject! { |t| t.blank? }

    if @workspace and not current_user.accessible_workspaces.include?(@workspace)
      render :plain => "You are not a member of this project", :layout => "forbidden", :status => 403 # Forbidden
      return
    end

    @workspaces = ( @workspace ? [@workspace] : current_user.accessible_workspaces )

    @workspaces = @workspaces.inject({}) do |hash, workspace|
      hosts = pro_search(:hosts,false,@search,workspace)
      services = pro_search(:services,false,@search,workspace)
      vulns = pro_search(:vulns,false,@search,workspace)


      hash[workspace] = {
        :hosts => hosts.sort_by(&:address_int),
        :vulns => vulns.sort_by(&:name),
        :services => services.sort{|a,b| [a.port, a.host.address_int] <=> [b.port, b.host.address_int]},
      }
      hash
    end
  end

protected

  def require_membership
    @workspace = Mdm::Workspace.find(params[:id])
    unless @workspace.usable_by?(current_user)
      render :plain => "You are not a member of this project", :layout => "forbidden", :status => 403 # Forbidden
    end
  end

  def require_manageability
    @workspace = Mdm::Workspace.find(params[:id])
    unless @workspace.manageable_by?(current_user)
      render :plain => "You are not the owner of this project", :layout => "forbidden", :status => 403 # Forbidden
    end
  end

  def log_changed_access(old_user_set, new_user_set)
    unless new_user_set == old_user_set
      AuditLogger.user("#{ip_user} - Project #{@workspace.name} access updated #{new_user_set}.")

      added_users = new_user_set - old_user_set
      removed_users = old_user_set - new_user_set

      added_message = if !added_users.empty?
        "added for #{added_users}"
      else
        ''
      end
      removed_message = if !removed_users.empty?
        "removed for #{removed_users}"
      else
        ''
      end
      joiner = if !added_message.empty? && !removed_message.empty?
        ' and '
      else
        ''
      end

      AuditLogger.user("#{ip_user} - Project #{@workspace.name} access #{added_message}#{joiner}#{removed_message}.")
    end
  end

  private

  def workspace_params
    params.fetch(:workspace, {}).permit!
  end

  def users_with_access
    @workspace.users.order(:id).select(:id, :username, :email).map {|u| u.as_json}
  end
end
