(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['apps/hosts/index/index_controller', 'apps/hosts/delete/delete_controller', 'lib/utilities/navigation', 'lib/components/flash/flash_controller'], function() {
    return this.Pro.module('HostsApp', function(HostsApp, App) {
      var API,
        _this = this;
      HostsApp.Router = (function(_super) {

        __extends(Router, _super);

        function Router() {
          return Router.__super__.constructor.apply(this, arguments);
        }

        Router.prototype.appRoutes = {
          "": "index",
          "hosts": "index",
          "hosts/:host_id": "show",
          "hosts/:host_id/:tab": "show"
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
          return initProRequire(['apps/hosts/index/index_controller'], function() {
            var indexController;
            loading = false;
            App.execute('loadingOverlay:hide');
            return indexController = new HostsApp.Index.Controller;
          });
        },
        show: function(host_id, tab) {
          var loading,
            _this = this;
          loading = true;
          _.delay((function() {
            if (loading) {
              return App.execute('loadingOverlay:show');
            }
          }), 50);
          return initProRequire(['/assets/hosts/backbone/controllers/host_view_controller-6e6371c826a1b256cf4c95c1118e7e80f9813613e56a22c3ca34b6388c52bc1a.js'], function(HostViewController) {
            var hostController;
            loading = false;
            App.execute('loadingOverlay:hide');
            hostController = new HostViewController({
              id: host_id
            });
            return hostController.Tab(tab != null ? tab : 'services', App.mainRegion);
          });
        },
        "delete": function(options) {
          return new HostsApp.Delete.Controller(options);
        }
      };
      App.addInitializer(function() {
        return new HostsApp.Router({
          controller: API
        });
      });
      App.addRegions({
        mainRegion: "#hosts-main-region"
      });
      App.vent.on("host:tag:added", function() {
        return App.execute('flash:display', {
          title: 'Host(s) Tagged ',
          message: 'The host(s) were successfully tagged.'
        });
      });
      return App.reqres.setHandler('hosts:delete', function(options) {
        if (options == null) {
          options = {};
        }
        return API["delete"](options);
      });
    });
  });

}).call(this);
