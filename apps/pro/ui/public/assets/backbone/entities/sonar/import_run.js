(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_model', 'base_collection'], function() {
    return this.Pro.module("Entities.Sonar", function(Sonar, App) {
      var API;
      Sonar.ImportRun = (function(_super) {

        __extends(ImportRun, _super);

        function ImportRun() {
          return ImportRun.__super__.constructor.apply(this, arguments);
        }

        ImportRun.prototype.url = function() {
          return Routes.workspace_sonar_imports_path(WORKSPACE_ID) + '.json';
        };

        return ImportRun;

      })(App.Entities.Model);
      API = {
        getImportRun: function(opts) {
          if (opts == null) {
            opts = {};
          }
          return new Sonar.ImportRun(opts);
        }
      };
      return App.reqres.setHandler("sonar:importRun:entity", function(opts) {
        if (opts == null) {
          opts = {};
        }
        return API.getImportRun(opts);
      });
    });
  });

}).call(this);
