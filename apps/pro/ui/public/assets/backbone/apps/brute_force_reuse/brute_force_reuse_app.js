(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['lib/concerns/entities/chooser', 'lib/concerns/views/chooseable', 'lib/utilities/navigation', 'apps/brute_force_reuse/cred_selection/cred_selection_controller', 'entities/cred', 'lib/components/window_slider/window_slider_controller', 'apps/brute_force_reuse/index/index_controller'], function() {
    return this.Pro.module('BruteForceReuseApp', function(BruteForceReuseApp, App) {
      var API;
      BruteForceReuseApp.Router = (function(_super) {

        __extends(Router, _super);

        function Router() {
          return Router.__super__.constructor.apply(this, arguments);
        }

        Router.prototype.appRoutes = {
          "reuse": "reuse"
        };

        return Router;

      })(Marionette.AppRouter);
      API = {
        reuse: function(id) {
          var indexController;
          if (id == null) {
            id = null;
          }
          return indexController = new BruteForceReuseApp.Index.Controller({
            core_id: id
          });
        }
      };
      App.addInitializer(function() {
        return new BruteForceReuseApp.Router({
          controller: API
        });
      });
      return App.vent.on("quickReuse:show", function(core_id) {
        App.navigate("#reuse", {
          trigger: false
        });
        return API.reuse(core_id);
      });
    });
  });

}).call(this);
