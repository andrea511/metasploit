//= require_tree ./backbone


window.jQuery(document).ready(function($) {
  new WebScanStatsView({ el: jQuery('#stats-container'),
                         workspaceId: $("meta[value='msp:workspace_id']").content,
                         taskId: $("meta[value='task_id']").content }).render()
});
