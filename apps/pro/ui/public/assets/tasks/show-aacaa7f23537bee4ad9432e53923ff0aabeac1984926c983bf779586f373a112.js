(function() {

  jQuery(document).bind('requirejs-ready', function() {
    return window.initRequire(['jquery', '/assets/shared/backbone/views/task_console-2b33ca95cff5e52d76224f72a04e65c43567724dde282154d9eec61ad3e31df3.js'], function($, TaskConsole, AppStatModalLayout, AppRun) {
      return $(document).ready(function() {
        var $appRunMeta, $log, $presenterMeta, appRunId, presenter, task, tc;
        $appRunMeta = $('meta[name=app_run_id]');
        $presenterMeta = $('meta[name=presenter]');
        if ($appRunMeta.length > 0) {
          appRunId = $appRunMeta.attr('content');
          return window.initRequire(['/assets/apps/backbone/views/layouts/app_stat_modal_layout-5c1838717f3af27537ebed7967861c6c969a7fe54228fbc2f54f6428fc8601ca.js', '/assets/apps/backbone/models/app_run-b01dfd5be9374d25d3eec5cf47fd005e5e1a790866141c147aee85c43af9b864.js'], function(AppStatModalLayout, AppRun) {
            var appRun,
              _this = this;
            appRun = new AppRun({
              id: appRunId
            });
            return appRun.fetch({
              success: function() {
                var region, statLayout;
                statLayout = new AppStatModalLayout({
                  appRun: appRun
                });
                region = new Backbone.Marionette.Region({
                  el: $('#appStats')
                });
                region.show(statLayout);
                return $('.app-stats').css({
                  padding: 0
                });
              }
            });
          });
        } else if ($presenterMeta.length > 0) {
          presenter = $presenterMeta.attr('content');
          return initProRequire(['apps/tasks/tasks_app'], function(TasksApp) {
            return Pro.start({
              environment: "development"
            });
          });
        } else {
          $(document).on('logUpdate', function(event, log, header) {
            return $('#taskDetails').html(header);
          });
          $log = $('#task_logs');
          task = $log.attr('task');
          tc = new TaskConsole({
            el: $log[0],
            task: task,
            prerendered: true
          });
          return tc.startUpdating();
        }
      });
    });
  });

}).call(this);
