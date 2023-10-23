(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['jquery', '/assets/task_chains/backbone/controller/task_chains_controller-bcf6c5294ff2592fb636a9f5669d512b27de4c0a3aa521da756789478aae3501.js'], function($, TaskChainsController) {
    var App;
    return App = (function() {

      function App() {
        this.start = __bind(this.start, this);

      }

      App.prototype.start = function() {
        var app;
        app = new Backbone.Marionette.Application;
        app.addInitializer(function() {
          var task_chains;
          task_chains = new TaskChainsController({
            legacyTasks: gon.legacy_tasks
          });
          return task_chains = task_chains.start();
        });
        return app.start();
      };

      return App;

    })();
  });

}).call(this);
