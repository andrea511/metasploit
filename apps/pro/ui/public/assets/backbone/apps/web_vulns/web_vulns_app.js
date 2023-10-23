(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['css!css/vulns', 'apps/hosts/hosts_app', 'lib/utilities/navigation', 'lib/components/window_slider/window_slider_controller'], function() {
    return this.Pro.module('WebVulnsApp', function(WebVulnsApp, App) {
      var API,
        _this = this;
      WebVulnsApp.Router = (function(_super) {

        __extends(Router, _super);

        function Router() {
          return Router.__super__.constructor.apply(this, arguments);
        }

        Router.prototype.appRoutes = {
          "": "index",
          "webvulns": "index",
          "webvulns/:id": "show"
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
          return initProRequire(['apps/web_vulns/index/index_controller'], function() {
            var indexController;
            loading = false;
            App.execute('loadingOverlay:hide');
            return indexController = new WebVulnsApp.Index.Controller;
          });
        },
        show: function(id) {
          var loading,
            _this = this;
          loading = true;
          return _.delay((function() {
            if (loading) {
              return App.execute('loadingOverlay:show');
            }
          }), 50);
        }
      };
      App.addInitializer(function() {
        return new WebVulnsApp.Router({
          controller: API
        });
      });
      return App.addRegions({
        mainRegion: "#web-vulns-main-region"
      });
    });
  });

}).call(this);
