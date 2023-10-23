class ListenersController < ApplicationController
  before_action :require_admin
  before_action :find_listener, :only => [:module_options, :start, :stop, :update, :edit]

  def index
    @listeners = Mdm::Listener.all
  end

  def new
    @listener = Mdm::Listener.new
    @listener.address = "0.0.0.0"
    @listener.port = rand(50000) + 10000
    build_workspace_list
    build_macro_list
    render :action => 'new'
  end

  def create
    @workspace = Mdm::Workspace.find(params[:listener].delete(:workspace))
    @listener = Mdm::Listener.new(listeners_params)
    @listener.owner = current_user.username
    @listener.workspace = @workspace

    if @listener.save
      AuditLogger.admin "#{ip_user} - Persistent listener created. #{audit_view(@listener.attributes)}"
      if @listener.start
        AuditLogger.admin "#{ip_user} - Persistent listener started. #{audit_view(@listener.attributes)}"
      end
      redirect_to listeners_path
    else
      build_workspace_list
      build_macro_list
      render :action => 'new'
    end
  end

  def stop
    if @listener.stop
      AuditLogger.admin "#{ip_user} - Persistent listener stopped. #{audit_view(@listener.attributes)}"
    end
    redirect_to listeners_path
  end

  def start
    if @listener.start
      AuditLogger.admin "#{ip_user} - Persistent listener started. #{audit_view(@listener.attributes)}"
    end
    redirect_to listeners_path
  end

  def destroy
    listeners = if params[:id]
                  [Mdm::Listener.find(params[:id])]
                elsif params[:listener_ids]
                  Mdm::Listener.find(params[:listener_ids])
                else
                  []
                end

    listeners.each do |l|
      if l.stop
        AuditLogger.admin "#{ip_user} - Persistent listener stopped. #{audit_view(l.attributes)}"
      end
    end

    Mdm::Listener.where(id: listeners.map(&:id)).destroy_all
    if listeners.empty?
      flash[:error] = "No Listeners selected to remove"
    else
      listeners.each { |l| AuditLogger.admin "#{ip_user} - Persistent listener deleted. #{audit_view(l.attributes)}" }
      flash[:notice] = view_context.pluralize(listeners.length, "Listener") + " removed"
    end
    redirect_to listeners_path
  end

  def edit
    @workspace_list = Mdm::Workspace.all.map { |x| [x.name, x.id] }
    @workspace_default = @listener.workspace.id
    @macro_list = [''] + Mdm::Macro.all.map { |x| x.name }
    @macro_default = @listener.macro
    build_module_list
  end

  def update
    tmp_listeners_params = listeners_params.dup
    @workspace = Mdm::Workspace.find(tmp_listeners_params.delete(:workspace))
    current = @listener.attributes.as_json
    @listener.update(tmp_listeners_params)
    @listener.workspace = @workspace
    @listener.save if @listener.changed?
    updated = @listener.attributes.as_json
    AuditLogger.admin "#{ip_user} - Persistent listener updated. #{audit_view(current, updated)}"
    if @listener.active? && @listener.restart
      AuditLogger.admin "#{ip_user} - Persistent listener restarted. #{audit_view(@listener.attributes)}"
    end
    redirect_to edit_listener_path(@listener)
  end

  def module_options
    m = MsfModule.find_by_fullname(params[:module])
    render :partial => 'module_fields', :locals => {:msf_module => m, :listener_id => nil}
  end

  protected

  def build_module_list
    @module_list = []
    MsfModule.post.each do |m|
      @module_list << m
    end

    @module_list = @module_list.sort_by { |m| m.title }
  end

  def build_workspace_list
    @workspace_list = Mdm::Workspace.all.map { |x| [x.name, x.id] }
    @workspace_default = Mdm::Workspace.last.id
  end

  def build_macro_list
    @macro_list = [''] + Mdm::Macro.all.map { |x| x.name }
    @macro_default = ''
  end

  def find_listener
    @listener = Mdm::Listener.find(params[:id])
  end

  private

  def listeners_params
    params.fetch(:listener, {}).permit!
  end

  def audit_view(current, updated=nil)
    if updated
      view = AuditHelper.compare(current, updated)
    else
      view = AuditHelper.show(current)
    end
    view
  end
end

