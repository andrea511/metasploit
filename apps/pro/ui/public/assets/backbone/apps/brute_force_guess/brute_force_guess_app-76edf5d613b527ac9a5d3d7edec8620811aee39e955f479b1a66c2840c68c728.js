(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['lib/utilities/navigation', 'apps/brute_force_guess/index/index_controller', 'entities/abstract/brute_force_guess', 'css!css/brute_force'], function() {
    return this.Pro.module('BruteForceGuessApp', function(BruteForceGuessApp, App) {
      var API;
      BruteForceGuessApp.Router = (function(_super) {

        __extends(Router, _super);

        function Router() {
          return Router.__super__.constructor.apply(this, arguments);
        }

        Router.prototype.appRoutes = {
          "quick": "quick"
        };

        return Router;

      })(Marionette.AppRouter);
      API = {
        quick: function() {
          return new BruteForceGuessApp.Index.Controller();
        }
      };
      App.addInitializer(function() {
        return new BruteForceGuessApp.Router({
          controller: API
        });
      });
      return App.addRegions({
        mainRegion: "#bruteforce-main-region"
      });
    });
  });

}).call(this);
