module Apps
  class AppRunsController < ApplicationController
    before_action :load_workspace
    before_action :require_workspace_membership

    def index
      respond_to do |format|
        format.html
        format.json do
          presenter = Apps::AppRunPresenter.new(load_app_runs, params)
          render :json => presenter.to_json
        end
      end
    end

    def show
      respond_to do |format|
        format.json do
          presenter = Apps::AppRunPresenter.new(load_app_run, params)
          render :json => presenter.to_json
        end
        format.html do
          @app_run = load_app_run
          @app_run_id = if @app_run.present? then @app_run.id else '' end
          render :index
        end
      end
    end

    def abort
      app_run = load_app_run
      app_run.abort!
      head(if app_run.aborted? then :ok else :error end)
    end

    def destroy
      app_run = load_app_run
      state = :err
      if app_run.present?
        app_run.destroy
        state = :ok
      end
      head state
    end

    private

    def load_app_runs
      Apps::AppRun.joins(:app)
                  .where(:workspace_id => @workspace.id, 'apps.hidden' => false)
                  .order('created_at DESC').includes(:app)
    end

    def load_app_run
      Apps::AppRun.where(
        :workspace_id => @workspace.id,
        :id => params[:id]
      ).first or raise_app_run_missing!
    end

    def raise_app_run_missing!
      raise ActiveRecord::RecordNotFound
    end

    def require_workspace_membership
      unless @workspace.usable_by?(current_user)
        raise "Member does not belong to workspace."
      end
    end
  end
end
