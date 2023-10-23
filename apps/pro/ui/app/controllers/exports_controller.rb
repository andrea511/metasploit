class ExportsController < ApplicationController

  before_action :load_workspace

  def index
    @exports = @workspace.exports
    respond_to do |format|
      format.html do
        render :action => "index", :layout => "application"
      end
      format.json do
        render :json => DataTableQueryResponse.build(params, {
          :collection => @exports,
          :search_cols => [:file_path, :created_by,
                           :state, :export_type],
          :columns => [:id, :file_path, :etype, :created_by, :state,
                       :created_at, :actions],
          :render_row => lambda { |export|
            { :file_path => File.basename(export.file_path), :etype => export.etype.pretty_name }
          }
        })
      end
    end
  end

  def new
    @export = Export.new(:export_type => :xml)
  end

  def create
    params[:export] ||= {}
    export_params = exports_params.merge(:workspace_id => @workspace.id)
    @export = Export.new(export_params)
    @export.created_by = current_user.username

    unless @export.save
      render :action => 'new',
             :locals => {:export => @export,
                         :error => @export.errors.full_messages.join('<br/>')
             },
             :status => :bad_request
      return
    end

    # Adds export generation process to DJ queue:
    @export.generate_delayed
    flash[:notice] = 'Export creation queued. Table will refresh shortly...'
    redirect_to workspace_exports_path(@workspace)
  end

  def download
    @export = Export.find(params[:id])
    export_filename = File.basename(@export.file_path)
    export_extension = File.extname(@export.file_path)[1..-1]

    file_types = {
        'xml'  => 'application/xml',
        'txt'  => 'text/plain',
        'zip'  => 'application/zip'
    }
    current_type = file_types[export_extension]

    file_data = File.open(@export.file_path, 'rb') { |f| f.read }
    # Prompt for file download:
    send_data(file_data,
              :type => current_type,
              :filename => export_filename)
  end

  def destroy
    @export.destroy
    flash[:notice] = "Deleted export #{@export.file_path}."
  end

  def destroy_multiple
    Export.where(id: params[:export_ids], workspace_id: @workspace.id).destroy_all

    respond_to do |format|
      format.any(:html, :js) do
        # TODO Not showing up
        flash.now[:notice] = "Deleted #{export_ids.size} exports."
        redirect_to workspace_exports_path(@workspace)
      end
      format.json {
        render :json => { success: true }
      }
    end
  end

  private

  def exports_params
    params.fetch(:export, {}).permit!
  end
end
