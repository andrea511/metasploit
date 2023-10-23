(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['jquery', '/assets/fuzzing/backbone/router-ba37ca130b55ffcc40b04bf1d8852e76cc647aa69927748e7ab9ea547aef5273.js'], function($, Router) {
    var App;
    App = (function() {

      function App() {
        this.start = __bind(this.start, this);

      }

      App.prototype.start = function() {
        var app;
        app = new Backbone.Marionette.Application();
        app.addInitializer(function() {
          new Router();
          return Backbone.history.start();
        });
        return app.start({});
      };

      return App;

    })();
    return $.ajaxSetup({
      'beforeSend': function(xhr) {
        return xhr.setRequestHeader("accept", "application/json");
      }
    });
  });

}).call(this);
