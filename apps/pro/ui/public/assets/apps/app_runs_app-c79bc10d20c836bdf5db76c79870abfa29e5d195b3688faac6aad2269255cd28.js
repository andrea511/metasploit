(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['jquery', '/assets/apps/backbone/controllers/app_runs_controller-f07185c4ec62be981da25f50efade006d0fd8aad36ed5dd7f2be091f0f73dbbe.js'], function($, AppRunsController) {
    var AppRunsApp;
    $('div.mainPad').css({
      padding: 0
    });
    $('div#crumbHolder').css({
      marginLeft: '15px'
    });
    return AppRunsApp = (function() {

      function AppRunsApp() {
        this.start = __bind(this.start, this);

      }

      AppRunsApp.prototype.start = function() {
        var app;
        this.region = new Backbone.Marionette.Region({
          el: '#global-apps-container'
        });
        this.controller = new AppRunsController({
          region: this.region
        });
        app = new Backbone.Marionette.Application;
        return app.start();
      };

      return AppRunsApp;

    })();
  });

}).call(this);
