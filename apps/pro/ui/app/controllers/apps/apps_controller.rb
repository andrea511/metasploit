module Apps
  class AppsController < ApplicationController
    before_action :load_workspace
    before_action :load_apps,            :only => :overview
    before_action :load_app_runs,        :only => :overview
    before_action :load_last_app_run_id, :only => :overview
    before_action :set_js_routes,        only: [:overview]

    def overview
      @licensed = License.get.supports_apps?
      @num_app_runs = load_app_runs.count
      load_last_app_run_id
    end

    private

    def load_apps
      @apps ||= Apps::App.where(:hidden => false).order('id DESC').includes(:app_categories)
    end

    def load_app_runs
      @app_runs ||= Apps::AppRun.joins(:app)
        .where(:workspace_id => @workspace.id, 'apps.hidden' => false)
    end

    def load_last_app_run_id
      load_app_runs
      last_run = @app_runs.order('id DESC').first
      @last_app_run_id = if last_run.present? then last_run.id else '' end
    end

    def set_js_routes
      gon.filter_values_apps_domino_task_config_index_path =
          filter_values_apps_domino_task_config_index_path(@workspace)
      gon.search_operators_apps_domino_task_config_index_path =
          search_operators_apps_domino_task_config_index_path(@workspace)
    end
  end
end
