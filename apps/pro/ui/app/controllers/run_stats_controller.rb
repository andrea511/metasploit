# Provides view layer with information on the stats associated w/ particular Mdm::Tasks
class RunStatsController < ApplicationController
  before_action :load_workspace

  # Retrieves the Task identified by params[:id],
  # checking to make sure that it's in the current workspace
  def show
    task = Mdm::Task.where(:id => params[:id], :workspace_id => @workspace.id).first

    if task.present?
      render :json => RunStat.where(task_id: task.id)
    else
      head :bad_request
    end
  end
end
