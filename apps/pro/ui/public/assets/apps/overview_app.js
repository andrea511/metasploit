(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['jquery', '/assets/apps/backbone/controllers/apps_overview_controller-1a971f1ebadf31c16f690a8929b2c2c644bf77982af809560110ba18355fa148.js'], function($, AppsOverviewController) {
    var OverviewApp;
    return OverviewApp = (function() {

      function OverviewApp() {
        this.start = __bind(this.start, this);

      }

      OverviewApp.prototype.start = function() {
        var app;
        this.region = new Backbone.Marionette.Region({
          el: '#global-apps-container'
        });
        this.controller = new AppsOverviewController({
          region: this.region
        });
        app = new Backbone.Marionette.Application;
        return app.start();
      };

      return OverviewApp;

    })();
  });

}).call(this);
