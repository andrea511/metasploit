class NexposeConsolesController < ApplicationController
  before_action :require_admin

  def index
    @consoles = Mdm::NexposeConsole.all
  end

  def new
    @console = Mdm::NexposeConsole.new
    render :action => 'new'
  end

  def create
    @console = Mdm::NexposeConsole.new(nexpose_console_params)
    @console.owner = current_user.username
    @console.status = "Initializing"
    if @console.save
      AuditLogger.admin "#{ip_user} - Nexpose console created. #{audit_view(@console.attributes)}"
      # now let's check the connection
      status = @console.check_status
      respond_to do |format|
        format.any(:html, :js) { redirect_to nexpose_consoles_path }
        format.json do
          render json: @console.as_json.merge(status)
        end
      end
    else
      respond_to do |format|
        format.any(:html, :js) { render :action => 'new' }
        format.json do
          render json: { success: false, errors: @console.errors.messages }, status: :error
        end
      end
    end
  end

  def destroy
    consoles = if params[:id]
      [ Mdm::NexposeConsole.find(params[:id]) ]
    elsif params[:nexpose_console_ids]
      Mdm::NexposeConsole.find(params[:nexpose_console_ids])
    else
      []
    end

    Mdm::NexposeConsole.where(id: consoles.map(&:id)).destroy_all
    respond_to do |format|
      format.any(:js, :html) do
        if consoles.empty?
          flash[:error] = "No Nexpose Consoles selected to remove"
        else
          consoles.each { |c| AuditLogger.admin "#{ip_user} - Nexpose console deleted. #{audit_view(c.attributes)}" }
          flash[:notice] = view_context.pluralize(consoles.length, "Nexpose Console") + " removed"
        end
        redirect_to nexpose_consoles_path
      end
      format.json { render json: { success: true } }
    end
  end

  def edit
    @console = Mdm::NexposeConsole.find(params[:id])
  end

  def update
    @console = Mdm::NexposeConsole.find(params[:id])
    current = @console.attributes.as_json
    if @console.update(nexpose_console_params)
      updated = @console.attributes.as_json
      AuditLogger.admin "#{ip_user} - Nexpose console updated. #{audit_view(current, updated)}"
      flash[:notice] = "Nexpose Console"
      redirect_to nexpose_consoles_path
    else
      render :action => 'edit'
    end
  end

  private

  def nexpose_console_params
    params.fetch(:nexpose_console, {}).permit!
  end

  def audit_view(current, updated=nil)
    if updated
      view = AuditHelper.compare(current, updated, filter: ['password'])
    else
      view = AuditHelper.show(current, filter: ['password'])
    end
    view
  end
end
