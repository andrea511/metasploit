(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_model', 'base_collection'], function() {
    return this.Pro.module("Entities.Nexpose", function(Nexpose, App) {
      var API;
      Nexpose.ImportRun = (function(_super) {

        __extends(ImportRun, _super);

        function ImportRun() {
          this.isFinished = __bind(this.isFinished, this);

          this.isReadyToImport = __bind(this.isReadyToImport, this);

          this.isNotYetStarted = __bind(this.isNotYetStarted, this);
          return ImportRun.__super__.constructor.apply(this, arguments);
        }

        ImportRun.prototype.urlRoot = function() {
          return Routes.workspace_nexpose_data_import_runs_path(WORKSPACE_ID);
        };

        ImportRun.prototype.isNotYetStarted = function() {
          return this.get('state') === 'not_yet_started';
        };

        ImportRun.prototype.isReadyToImport = function() {
          return this.get('state') === 'ready_to_import';
        };

        ImportRun.prototype.isFinished = function() {
          return this.get('state') === 'finished';
        };

        return ImportRun;

      })(App.Entities.Model);
      API = {
        getImportRun: function(opts) {
          var sites;
          if (opts == null) {
            opts = {};
          }
          sites = new Nexpose.ImportRun(opts);
          return sites;
        }
      };
      return App.reqres.setHandler("nexpose:importRun:entity", function(opts) {
        if (opts == null) {
          opts = {};
        }
        return API.getImportRun(opts);
      });
    });
  });

}).call(this);
