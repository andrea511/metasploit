# Provides view layer with information on the active WebScan task
class WebScansController < ApplicationController
  before_action :load_workspace

  # Retrieves the Task identified by params[:id],
  # checking to make sure that it's in the current workspace
  def show
    @task = Mdm::Task.where("id = ? AND workspace_id = ?", params[:id], @workspace.id).first

    if @task.present?
      web_scan = WebScanPresenter.new(@task)

      respond_to do |format|
        format.json { render :json => web_scan.to_json}
        format.html
      end
    else
      head :bad_request
    end
  end

end
