(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['apps/services/index/index_controller', 'apps/services/delete/delete_controller', 'lib/utilities/navigation', 'lib/components/flash/flash_controller'], function() {
    return this.Pro.module('ServicesApp', function(ServicesApp, App) {
      var API,
        _this = this;
      ServicesApp.Router = (function(_super) {

        __extends(Router, _super);

        function Router() {
          return Router.__super__.constructor.apply(this, arguments);
        }

        Router.prototype.appRoutes = {
          "": "index",
          "services": "index"
        };

        return Router;

      })(Marionette.AppRouter);
      API = {
        index: function() {
          var loading,
            _this = this;
          loading = true;
          _.delay((function() {
            if (loading) {
              return App.execute('loadingOverlay:show');
            }
          }), 50);
          return initProRequire(['apps/services/index/index_controller'], function() {
            var indexController;
            loading = false;
            App.execute('loadingOverlay:hide');
            return indexController = new ServicesApp.Index.Controller;
          });
        },
        "delete": function(options) {
          return new ServicesApp.Delete.Controller(options);
        }
      };
      App.addInitializer(function() {
        return new ServicesApp.Router({
          controller: API
        });
      });
      App.addRegions({
        mainRegion: "#services-main-region"
      });
      App.reqres.setHandler('services:delete', function(options) {
        if (options == null) {
          options = {};
        }
        return API["delete"](options);
      });
      return App.vent.on("host:tag:added", function() {
        return App.execute('flash:display', {
          title: 'Host(s) Tagged ',
          message: 'The host(s) were successfully tagged.'
        });
      });
    });
  });

}).call(this);
