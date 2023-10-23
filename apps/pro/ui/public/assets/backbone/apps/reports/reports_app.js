(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['apps/reports/show/show_controller', 'entities/report', 'entities/report_artifact'], function() {
    return this.Pro.module('ReportsApp', function(ReportsApp, App) {
      var API;
      ReportsApp.Router = (function(_super) {

        __extends(Router, _super);

        function Router() {
          return Router.__super__.constructor.apply(this, arguments);
        }

        Router.prototype.appRoutes = {
          "reports/:id": "show"
        };

        return Router;

      })(Marionette.AppRouter);
      API = {
        show: function(id, report, reportArtifacts) {
          if (report == null) {
            report = App.request('new:reports:entity', gon.report);
          }
          if (reportArtifacts == null) {
            reportArtifacts = App.request('new:report_artifacts:entities', gon.report.report_artifacts);
          }
          return new ReportsApp.Show.Controller({
            id: report.id,
            report: report,
            reportArtifacts: reportArtifacts
          });
        }
      };
      App.vent.on('show:report', function(report, reportArtifacts) {
        return API.show(report.id, report, reportArtifacts);
      });
      App.addInitializer(function() {
        return new ReportsApp.Router({
          controller: API
        });
      });
      App.addInitializer(function() {
        return API.show();
      });
      App.addRegions({
        mainRegion: "#reports-main-region"
      });
      return App.addInitializer(function() {
        return this.module("ReportsApp").start();
      });
    });
  });

}).call(this);
