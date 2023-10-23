class TaskChainPresenter < DelegateClass(TaskChain)
  include ActionView::Helpers

  def pretty_updated_at
    l(updated_at, format: :short_datetime)
  end

  def sortable_updated_at
    updated_at.to_i
  end

  def last_run_task_state
    if last_run_task.try(:state?)
      last_run_task["state"]
    else
      ''
    end
  end

  def schedule_state
    if suspended?
      'suspended'
    elsif running?
      'running'
    elsif last_run_task_state == "interrupted"
      'failed'
    elsif schedule.nil? && next_run_at.nil?
      'unscheduled'
    elsif schedule_hash["frequency"] == "once"
      'once'
    else
      'scheduled'
    end
  end

  def created_by
    user.try(:username)
  end

  def task_names
    scheduled_tasks.collect { |task| task.kind.gsub('_', ' ') }.join(', ')
  end

  def pretty_last_run_at
    if last_run_at.nil?
      'Never Run'
    else
      'Last Run ' + l(last_run_at, format: :short_text_date)
    end
  end

  def pretty_next_run_at
    unless running?
      if next_run_at.nil?
        if schedule_hash["frequency"] == "daily" && schedule_hash["daily"]["start_date"] == ""
          'Unscheduled'
        elsif last_run_task_state == "interrupted"
          'Failed'
        elsif suspended?
          'Paused'
        else
          'Expired'
        end
      else
        'Next Run ' + l(next_run_at, format: :short_text_date)
      end
    else #show nothing when the task chain is running
      ''
    end
  end

  def sortable_next_run_at
    next_run_at.to_i
  end

  def started_tasks
    active_scheduled_task.position if calculate_running?
  end

  def percent_tasks_started
    ((started_tasks.to_f/total_tasks.to_f) * 100).to_i if calculate_running?
  end

  def total_tasks
    scheduled_tasks.count
  end

  def current_task_name
    if active_report_id
      'Reporting'
    else
      if active_task
        active_task.description
      end
    end
  end

  def calculate_running?
    running? && ((active_scheduled_task_id && active_task_id) || active_report_id )
  end
end