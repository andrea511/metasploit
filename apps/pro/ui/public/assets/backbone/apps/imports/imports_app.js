(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['lib/utilities/navigation', 'apps/imports/index/index_controller', 'apps/imports/index/type', 'css!css/imports'], function() {
    return this.Pro.module('ImportsApp', function(ImportsApp, App) {
      var API, Index;
      Index = ImportsApp.Index;
      ImportsApp.Router = (function(_super) {

        __extends(Router, _super);

        function Router() {
          return Router.__super__.constructor.apply(this, arguments);
        }

        Router.prototype.appRoutes = {
          "": "import",
          "nexpose": "importNexpose",
          "file": "importFile",
          "sonar": "importSonar"
        };

        return Router;

      })(Marionette.AppRouter);
      API = {
        "import": function(type) {
          if (type == null) {
            type = Index.Type.Nexpose;
          }
          return new ImportsApp.Index.Controller({
            type: type
          });
        },
        importNexpose: function() {
          return API["import"](Index.Type.Nexpose);
        },
        importFile: function() {
          return API["import"](Index.Type.File);
        },
        importSonar: function() {
          return API["import"](Index.Type.Sonar);
        }
      };
      App.addInitializer(function() {
        return new ImportsApp.Router({
          controller: API
        });
      });
      App.addRegions({
        mainRegion: "#imports-main-region"
      });
      return App.vent.on("import:typeChange", function(type) {
        return App.navigate("#" + type, {
          trigger: false
        });
      });
    });
  });

}).call(this);
