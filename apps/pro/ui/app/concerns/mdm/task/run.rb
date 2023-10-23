module Mdm::Task::Run
  # Task modules that can be paused and resumed.
  PAUSABLE_MODULES = [ 'pro/bruteforce/reuse' ]

  def done?
    completed?
  end

  def has_error?
    error.present?
  end

  def indeterminate?
    running? && progress == -1
  end

  def pausable?
    PAUSABLE_MODULES.include?(self[:module])
  end

  def rpc_pause
    execute_rpc_task_action :pause
  end

  def rpc_resume
    execute_rpc_task_action :resume
  end

  def rpc_stop
    execute_rpc_task_action :stop
  end

  private

  def execute_rpc_task_action(action)
    c = Pro::Client.get
    c.send("task_#{action}", id)
    id
  end
end
