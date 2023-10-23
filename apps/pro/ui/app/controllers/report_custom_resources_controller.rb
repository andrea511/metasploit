class ReportCustomResourcesController < ApplicationController

  include Metasploit::Pro::Report::Exceptions

  before_action :load_workspace
  before_action :require_admin, :only => [:destroy]

  def show
    resource = ReportCustomResource.find(params[:id])
    resource_filename = File.basename(resource.file_path)
    resource_extension = File.extname(resource.file_path)[1..-1]

    file_types = {
        'jrxml'  => 'text/xml',
        'jasper' => 'application/octet-stream',
        'png'    => 'image/png',
        'gif'    => 'image/gif',
        'jpeg'   => 'image/jpeg',
        'jpg'    => 'image/jpeg'
    }
    current_type = file_types[resource_extension]

    file_data = File.read(resource.file_path)
    send_data(file_data,
              :type => current_type,
              :disposition => :attachment,
              :filename => resource_filename)
  end

  def destroy
    resource = ReportCustomResource.find(params[:id])
    res_name = resource.name
    resource.destroy
    flash[:notice] = "Deleted custom report resource #{res_name}."
    render_js_redirect(new_workspace_custom_report_path(@workspace))
  end

  def create
    @resource = ReportCustomResource.new(
        :workspace => @workspace,
        :created_by => @current_user.username
    )
    custom_resource = params[:report_custom_resource]
    @resource.name = custom_resource[:name]
    @resource.file_data = custom_resource[:file_data]

    if @resource.save
      render :partial => 'wizards/pass_data',
             :locals => { :data => { :success => :ok } }
    else
      render :partial => 'wizards/pass_data',
             :locals => {
                 :data => @resource.errors.messages.as_json.merge({:success => false})
             }
    end
  end

end
