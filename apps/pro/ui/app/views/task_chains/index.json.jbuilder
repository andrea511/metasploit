json.array! @task_chains do |task_chain|
  json.id task_chain.id
  json.name task_chain.name
  json.last_updated task_chain.pretty_updated_at
  json.sortable_last_updated task_chain.sortable_updated_at
  json.created_by task_chain.created_by
  json.task_names task_chain.task_names
  json.last_run task_chain.pretty_last_run_at
  json.next_run task_chain.pretty_next_run_at
  json.sortable_next_run task_chain.sortable_next_run_at
  json.schedule_state task_chain.schedule_state
  json.started_tasks task_chain.started_tasks
  json.percent_tasks_started task_chain.percent_tasks_started
  json.total_tasks task_chain.total_tasks
  json.state task_chain.state
  json.current_task_name task_chain.current_task_name
  json.last_run_task_state task_chain.last_run_task_state

  if task_chain.active_task && task_chain.active_report_id.nil?
    json.current_task_url task_detail_path(@workspace, task_chain.active_task)
  else
    json.current_task_url 'javascript:void(0)'
  end

  if task_chain.last_run_report
    json.last_run_url workspace_report_path(@workspace, task_chain.last_run_report_id)
  elsif task_chain.last_run_task
    json.last_run_url task_detail_path(@workspace, task_chain.last_run_task_id)
  end

  if task_chain.last_run_report.try(:failed?) || task_chain.last_run_task.try(:error?)
    json.last_run_error true
  end

  # URLs
  json.clone_workspace_task_chain_path clone_workspace_task_chain_path(@workspace, task_chain)
  json.edit_workspace_task_chain_path edit_workspace_task_chain_path(@workspace, task_chain)
end