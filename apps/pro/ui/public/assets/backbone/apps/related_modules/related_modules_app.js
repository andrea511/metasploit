(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['css!css/vulns', 'apps/hosts/hosts_app', 'lib/utilities/navigation', 'lib/components/window_slider/window_slider_controller'], function() {
    return this.Pro.module('RelatedModulesApp', function(RelatedModulesApp, App) {
      var API,
        _this = this;
      RelatedModulesApp.Router = (function(_super) {

        __extends(Router, _super);

        function Router() {
          return Router.__super__.constructor.apply(this, arguments);
        }

        Router.prototype.appRoutes = {
          "": "index",
          "related_modules": "index"
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
          return initProRequire(['apps/related_modules/index/index_controller'], function() {
            var indexController;
            loading = false;
            App.execute('loadingOverlay:hide');
            return indexController = new RelatedModulesApp.Index.Controller;
          });
        }
      };
      App.addInitializer(function() {
        return new RelatedModulesApp.Router({
          controller: API
        });
      });
      return App.addRegions({
        mainRegion: "#related-modules-main-region"
      });
    });
  });

}).call(this);
