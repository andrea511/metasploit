jQueryInWindow ($) ->
  $(document).ready ->
    TASK_ID      = $('meta[name=task_id]').attr('content')

    new WebScanStatsView(
      el: $('#stats-container'),
      workspaceId: WORKSPACE_ID,
      taskId: TASK_ID
    ).render()