class MacrosController < ApplicationController
  before_action :require_admin
  before_action :find_macro, :only => [:module_options, :add_action, :delete_action, :update, :edit]

  def index
    @macros = Mdm::Macro.all
  end

  def new
    @macro = Mdm::Macro.new
    render :action => 'new'
  end

  def create
    @macro = Mdm::Macro.new(macros_params)
    @macro.owner = current_user.username
    if @macro.save
      AuditLogger.admin "#{ip_user} - Macro created. #{audit_view(@macro.attributes)}"
      redirect_to edit_macro_path(@macro)
    else
      render :action => 'new'
    end
  end

  def destroy
    macros = if params[:id]
               [Mdm::Macro.find(params[:id])]
             elsif params[:macro_ids]
               Mdm::Macro.find(params[:macro_ids])
             else
               []
             end

    Mdm::Macro.where(id: macros.map(&:id)).destroy_all
    if macros.empty?
      flash[:error] = "No Macros selected to remove"
    else
      flash[:notice] = view_context.pluralize(macros.length, "Macro") + " removed"
      macros.each { |macro| AuditLogger.admin "#{ip_user} - Macro deleted. #{audit_view(macro.attributes)}" }
    end
    redirect_to macros_path
  end

  def edit
    build_module_list
  end

  def update
    current = @macro.attributes.as_json
    if @macro.update(macros_params)
      updated = @macro.attributes.as_json
      AuditLogger.admin "#{ip_user} - Macro updated. #{audit_view(current, updated)}"
      flash[:notice] = "Macro #{@macro.name} updated"
      redirect_to edit_macro_path(@macro)
    else
      render :action => 'edit'
    end
  end

  def module_options
    m = MsfModule.find_by_fullname(params[:module])
    render :partial => 'module_fields', :locals => {:msf_module => m, :macro_id => nil, :action_index => nil}
  end

  def delete_action
    current = @macro.attributes.as_json
    deleted_actions = []
    params[:action_ids].each do |action_id|
      deleted_actions << @macro.actions[action_id.to_i]
      @macro.actions[action_id.to_i] = nil
    end
    @macro.actions.delete(nil)
    @macro.save
    updated = @macro.attributes.as_json
    AuditLogger.admin "#{ip_user} - Action(s) deleted from macro. #{audit_view(current, updated)}"
    flash[:notice] = view_context.pluralize(params[:action_ids].length, "Action") + " removed"
    redirect_to edit_macro_path(@macro)
  end

  def add_action
    mname = params[:module]
    mopts = {}
    if params[:options]
      mopts = params[:options].dup.permit!.to_h # look at stack for where this param can come from.
    end
    current = @macro.attributes.as_json
    @macro.add_action(mname, mopts)
    updated = @macro.attributes.as_json
    AuditLogger.admin "#{ip_user} - Action added to macro. #{audit_view(current, updated)}"
    redirect_to edit_macro_path(@macro)
  end

  protected

  def build_module_list
    @module_list = []
    MsfModule.post.each do |m|
      @module_list << m
    end

    @module_list = @module_list.sort_by { |m| m.title }
  end

  def find_macro
    @macro = Mdm::Macro.find(params[:id])
  end

  private

  def audit_view(current, updated=nil)
    if updated
      view = AuditHelper.compare(current, updated)
    else
      view = AuditHelper.show(current)
    end
    view
  end

  def macros_params
    params.fetch(:macro, {}).permit!
  end
end

