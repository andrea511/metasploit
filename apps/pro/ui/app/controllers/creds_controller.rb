class CredsController < ApplicationController

  before_action :load_workspace
  before_action :load_services, :only => [:new, :edit]
  before_action :store_return_path, :only => [:new, :edit, :destroy]

  include TableResponder

  def index
  end

  def new
    @cred = Mdm::Cred.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @cred = Mdm::Cred.find(params[:id])


    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
    @cred = Mdm::Cred.new(params[:cred])

    respond_to do |format|
      if @cred.save
        flash[:notice] = 'Authentication Token was successfully created.'
        format.html { redirect_back }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @cred = Mdm::Cred.find(params[:id])

    respond_to do |format|
      if @cred.update(params[:cred])
        flash[:notice] = 'Authentication Token was successfully updated.'
        format.html { redirect_back }
      else
        flash[:error] = 'There was an error saving the Authentication Token.'
        format.html { redirect_to(workspace_creds_path(@workspace)) }
      end
    end
  end

  def destroy_multiple
    cred_ids = params[:id] || params[:cred_ids] || []
    creds = Mdm::Cred.where(id: cred_ids, workspace_id: @workspace.id).destroy_all

    if creds.empty?
      flash[:error] = 'No Authentication Tokens selected to remove'
    else
      flash[:notice] = view_context.pluralize(creds.size, 'Authentication Token') + ' removed'
    end
    redirect_back
  end

  private
  def store_return_path
    session[:return_to] = request.referer
  end


  def load_services
    if params[:host_id]
      @host = Mdm::Host.find(params[:host_id])
      @services = @host.services
    end

    if @services.nil? || @services.empty?
      @services = Mdm::Service.where(["host_id IN (SELECT id FROM hosts WHERE workspace_id = ?)", @workspace.id]).
        order("name ASC")
    end
  end
end

