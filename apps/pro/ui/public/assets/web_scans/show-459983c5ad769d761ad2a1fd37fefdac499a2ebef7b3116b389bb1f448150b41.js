(function() {

  jQueryInWindow(function($) {
    return $(document).ready(function() {
      var TASK_ID;
      TASK_ID = $('meta[name=task_id]').attr('content');
      return new WebScanStatsView({
        el: $('#stats-container'),
        workspaceId: WORKSPACE_ID,
        taskId: TASK_ID
      }).render();
    });
  });

}).call(this);
