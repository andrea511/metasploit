(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['jquery', '/assets/tasks/new_nexpose_exception_push/backbone/controllers/exception_push_controller-7eb52d313151534c8487ce09a02f3284102a3c1d59bae2c6f392b620ffb0cadd.js'], function($, ExceptionPushController) {
    var App;
    return App = (function() {

      function App() {
        this.start = __bind(this.start, this);

      }

      App.prototype.start = function() {
        var app;
        app = new Backbone.Marionette.Application;
        app.addInitializer(function() {
          var exception_push;
          exception_push = new ExceptionPushController();
          return exception_push.start();
        });
        return app.start();
      };

      return App;

    })();
  });

}).call(this);
