require 'msf_module_commander'

module Msf::Pro
module Apps
module Helpers
  include ::MsfModuleCommander

  # Common to any App module run
  attr_reader :mdm_task, :app_run

  # @return [Integer] the id of the associated Report
  def report_id
    app_run.config['report_id']
  end

  # Returns true if there data in the AppRun#config at the standardized report sub-config key
  def app_run_contains_report?
    report_id.present?
  end

  # Runs the report task with the config included in the AppRun's serialized config
  def run_report
    app_run.enable_report!

    report = Report.find(report_id)
    report.update_attribute(:app_run_id, app_run.id)
    report.generate_delayed
  end

  # @return[Apps::AppRun] the Apps::AppRun that contains config for this
  def app_run
    @app_run ||= ::Apps::AppRun.find(datastore['APP_RUN_ID'])
  end

  # Convenience -- also helps to differentiate the DB representation (Mdm::Task)
  # from the myraid other kinds of "Task" on this side of the RPC bridge (yeesh)
  def mdm_task
    @mdm_task ||= self[:task].nil? ? nil : self[:task].record
  end

  # Called when the AppRun's calling task is cleaned up and the AppRun is in "completed" state
  # Override in commander for more detailed notification message
  # @return[Notifications::Message]
  def completed_notification
    generic_notification("completed")
  end

  # Called when the AppRun's calling task is cleaned up and the AppRun is in "failed" state
  # Override in commander for more detailed notification message
  # @return[Notifications::Message]
  def failed_notification
    generic_notification("failed")
  end

  # Called when the AppRun's calling task is cleaned up and the AppRun is in "aborted" state
  # Override in commander for more detailed notification message
  # @return[Notifications::Message]
  def aborted_notification
    generic_notification("aborted")
  end

  def generic_notification(state)
    Notifications::Message.new(default_notification_options(state))
  end

  def default_notification_options(state='completed')
    task_info = if mdm_task.info.present? then mdm_task.info else "MetaModule #{state}" end
    {
      :workspace => mdm_task.workspace,
      :title => "#{state.capitalize}: #{app_run.app.name}",
      :url => generic_notification_path,
      :content => task_info,
      :kind => :metamodule_notification
    }
  end

  # @return[String] path to Mdm::Task that ran the AppRun
  def generic_notification_path
    if app_run.completed? and app_run_contains_report?
      "/workspaces/#{mdm_task.workspace_id}/reports"
    else
      "/workspaces/#{mdm_task.workspace_id}/tasks/#{mdm_task.id}"
    end
  end

  def cleanup
    app_run.reload.complete! # noop if app is already failed or aborted
    super
  end
end
end
end
