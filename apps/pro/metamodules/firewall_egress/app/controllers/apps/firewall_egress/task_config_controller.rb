class Apps::FirewallEgress::TaskConfigController < Apps::BaseController
  #TODO: Move Constant back to Task Config when we namespace Metamodules correctly
  # Each tab on the multi-page form gets its own "step"
  STEPS = [:configure_scan, :generate_report]
  steps(*STEPS)

  # TODO: this is almost exactly the same as the BaseController, except for
  # the :path option on render_success
  def launch
    build_objects

    if task_valid? && @report.save
      @task_config.report = @report
      task = @task_config.launch!

      render_success(
        :path => main_app.workspace_apps_run_path(
          task.workspace.id, task.app_run_id
        )
      )
    else
      render_task_errors
    end
  end

  private

  def set_report_type
    @report_type = Apps::FirewallEgress::TaskConfig::REPORT_TYPE
  end
end
