(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['apps/tasks/show/show_controller', 'entities/task'], function() {
    return this.Pro.module('TasksApp', function(TasksApp, App) {
      var API;
      TasksApp.Router = (function(_super) {

        __extends(Router, _super);

        function Router() {
          return Router.__super__.constructor.apply(this, arguments);
        }

        Router.prototype.appRoutes = {
          "": "index"
        };

        return Router;

      })(Marionette.AppRouter);
      API = {
        index: function(opts) {
          var task;
          if (opts == null) {
            opts = {};
          }
          task = new App.Entities.Task({
            id: opts.task_id || window.TASK_ID,
            workspace_id: opts.workspace_id || window.WORKSPACE_ID
          });
          return new TasksApp.Show.Controller({
            task: task
          });
        }
      };
      App.addRegions({
        mainRegion: "#tasks-app"
      });
      return App.addInitializer(function() {
        new TasksApp.Router({
          controller: API
        });
        return API.index();
      });
    });
  });

}).call(this);
