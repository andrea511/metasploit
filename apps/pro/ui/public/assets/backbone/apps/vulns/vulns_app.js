(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['css!css/vulns', 'apps/hosts/hosts_app', 'lib/utilities/navigation', 'apps/vulns/delete/delete_controller', 'lib/shared/nexpose_push/nexpose_push_controllers', 'lib/components/window_slider/window_slider_controller'], function() {
    return this.Pro.module('VulnsApp', function(VulnsApp, App) {
      var API,
        _this = this;
      VulnsApp.Router = (function(_super) {

        __extends(Router, _super);

        function Router() {
          return Router.__super__.constructor.apply(this, arguments);
        }

        Router.prototype.appRoutes = {
          "": "index",
          "vulns": "index",
          "vulns/:id": "show"
        };

        return Router;

      })(Marionette.AppRouter);
      API = {
        index: function() {
          var loading, _ref,
            _this = this;
          if (((_ref = window.gon) != null ? _ref.route : void 0) === 'show') {
            this.show(window.gon.id);
            return false;
          }
          loading = true;
          _.delay((function() {
            if (loading) {
              return App.execute('loadingOverlay:show');
            }
          }), 50);
          return initProRequire(['apps/vulns/index/index_controller'], function() {
            var indexController;
            loading = false;
            App.execute('loadingOverlay:hide');
            return indexController = new VulnsApp.Index.Controller;
          });
        },
        show: function(id) {
          var loading,
            _this = this;
          loading = true;
          _.delay((function() {
            if (loading) {
              return App.execute('loadingOverlay:show');
            }
          }), 50);
          window.VULN_ID = id;
          return initProRequire(['apps/vulns/show/show_controller'], function(ShowController) {
            var controller;
            loading = false;
            App.execute('loadingOverlay:hide');
            return controller = new VulnsApp.Show.Controller({
              id: id != null ? id : window.VULN_ID,
              workspace_id: window.WORKSPACE_ID
            });
          });
        },
        "delete": function(options) {
          return new VulnsApp.Delete.Controller(options);
        }
      };
      App.addInitializer(function() {
        return new VulnsApp.Router({
          controller: API
        });
      });
      App.addRegions({
        mainRegion: "#vulns-main-region"
      });
      return App.reqres.setHandler('vulns:delete', function(options) {
        if (options == null) {
          options = {};
        }
        return API["delete"](options);
      });
    });
  });

}).call(this);
