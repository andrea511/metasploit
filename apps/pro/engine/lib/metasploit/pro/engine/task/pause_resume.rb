require 'metasploit/pro/engine/task'

# This module should be mixed into Metasploit Pro modules (classes of {Metasploit3})
# in order to provide functionality for pausing and resuming tasks.
#
# This module enforces definition of certain methods in order to confirm that a given {Metasploit3}
# satisfies the pause/resume interface.
#

module Metasploit::Pro::Engine::Task::PauseResume

  # Name of the pausing method implemented on a {Metasploit3} satisfying the pause/resume interface
  PAUSE_METHOD_NAME  = :pause_task
  # Name of the resuming method implemented on a {Metasploit3} satisfying the pause/resume interface
  RESUME_METHOD_NAME = :resume_task
  # The names of the methods required to be defined on target classes
  REQUIRED_INTERFACE_METHOD_NAMES = [:pause_task, :resume_task]

  # (Override in target) defines code to be executed when the user requests a task be paused
  # @return[void]
  def pause_task
    fail "Must be defined in target class"
  end

  # (Override in target) defines code to be executed when the user requests a task be resumed
  # @return[void]
  def resume_task
    fail "Must be defined in target class"
  end

  # Returns true if the requested action is +pause+
  # @return [Boolean] whether task running this module was paused
  def task_was_paused?
    datastore[::Pro::ProTask::REQUESTED_TASK_ACTION_DS_KEY] == Pro::ProTask::PAUSE
  end

  # Returns true if the requested action is +resume+
  # @return [Boolean] whether task running this module was resumed
  def task_was_resumed?
    datastore[::Pro::ProTask::REQUESTED_TASK_ACTION_DS_KEY] == Pro::ProTask::RESUME
  end

  # Returns true if the requested action is +stop+
  # @return [Boolean] whether task running this module was stopped
  def task_was_stopped?
    datastore[::Pro::ProTask::REQUESTED_TASK_ACTION_DS_KEY] == Pro::ProTask::STOP
  end
end