(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['jquery', '/assets/hosts/backbone/controllers/host_view_controller-6e6371c826a1b256cf4c95c1118e7e80f9813613e56a22c3ca34b6388c52bc1a.js', '/assets/hosts/router-81e8b80f7f8ecf11b287195061c9d7c3d4f25b9704ef145f4d2296c1789c6974.js'], function($, HostViewController, Router) {
    var HostViewApp;
    return HostViewApp = (function() {

      function HostViewApp() {
        this.start = __bind(this.start, this);

      }

      HostViewApp.prototype.start = function() {
        var app;
        window.HostViewAppRouter = Router;
        app = new Backbone.Marionette.Application;
        app.addInitializer(function() {
          return Backbone.history.start();
        });
        return app.start();
      };

      return HostViewApp;

    })();
  });

}).call(this);
