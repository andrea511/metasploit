class ApiKeysController < ApplicationController
  before_action :require_admin
  before_action :load_api_key, :only => [:edit, :update, :reveal]

  def index
    @api_keys = Mdm::ApiKey.all
  end

  def new
    @api_key = Mdm::ApiKey.new
    @api_key.token = Mdm::ApiKey.generated_token
    render :action => 'new'
  end

  def create
    @api_key = Mdm::ApiKey.new(api_key_params)
    if @api_key.save
      AuditLogger.admin "#{ip_user} - API key created. #{audit_view(@api_key.attributes)}"
      redirect_to api_keys_path
    else
      render :action => 'new'
    end
  end

  def destroy
    api_keys = if params[:id]
                 [Mdm::ApiKey.find(params[:id])]
               elsif params[:api_key_ids]
                 Mdm::ApiKey.find(params[:api_key_ids])
               else
                 []
               end

    Mdm::ApiKey.where(id: api_keys.map(&:id)).destroy_all
    if api_keys.empty?
      flash[:error] = "No API Keys selected to remove"
    else
      flash[:notice] = view_context.pluralize(api_keys.length, "API Key") + " removed"
      api_keys.each { |key| AuditLogger.admin "#{ip_user} - API key deleted. #{audit_view(key.attributes)}" }
    end
    redirect_to api_keys_path
  end

  def edit
    @api_key = Mdm::ApiKey.find(params[:id])
  end

  def update
    @api_key = Mdm::ApiKey.find(params[:id])
    current = @api_key.attributes.as_json
    if @api_key.update(api_key_params)
      updated = @api_key.attributes.as_json
      flash[:notice] = "API Key updated"
      AuditLogger.admin "#{ip_user} - API key udpated. #{audit_view(current, updated)}"
      redirect_to api_keys_path
    else
      render :action => 'edit'
    end
  end

  def reveal
    api_key = ERB::Util::h(@api_key.token)
    render :plain => "<strong>#{api_key}</strong>"
    AuditLogger.admin "#{ip_user} - API key revealed. #{audit_view(@api_key.attributes)}"
  end

  private

  def load_api_key
    @api_key = Mdm::ApiKey.find(params[:id])
  end

  def audit_view(current, updated=nil)
    if updated
      view = AuditHelper.compare(current, updated, filter: ['token'])
    else
      view = AuditHelper.show(current, filter: ['token'])
    end
    view
  end

  def api_key_params
    params.fetch(:api_key, {}).permit!
  end
end

