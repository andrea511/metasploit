module <%= file_name.camelize %>
  class TaskConfigController < Apps::BaseController


    #TODO: Move Constant back to Task Config when we namespace Metamodules correctly
    # Each tab on the multi-page form gets its own "step"
    STEPS = [:configure_scan, :generate_report]
    steps(*STEPS)

    # TODO: While this is provided in the base controller, the version there
    # differs slightly in the path for the render_success call, thus this will
    # need to remain in place until all metamodules are refactored out of the main
    # pro codebase.
    def launch
      @task_config = build_task_config
      if @task_config.valid?
        task = @task_config.launch!
        render_success(
            :path => main_app.workspace_apps_run_path(
                task.workspace.id, task.app_run_id
            )
        )
      else
        render_errors(:task_config => @task_config.errors.messages)
      end
    end

    private

    def set_report_type
      @report_type = <%= file_name.camelize %>::TaskConfig::REPORT_TYPE
    end
  end
end
