(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_model', 'base_collection'], function() {
    return this.Pro.module("Entities", function(Entities, App) {
      var API;
      Entities.Report = (function(_super) {

        __extends(Report, _super);

        function Report() {
          return Report.__super__.constructor.apply(this, arguments);
        }

        return Report;

      })(App.Entities.Model);
      Entities.ReportCollection = (function(_super) {

        __extends(ReportCollection, _super);

        function ReportCollection() {
          return ReportCollection.__super__.constructor.apply(this, arguments);
        }

        ReportCollection.prototype.model = Entities.Report;

        return ReportCollection;

      })(App.Entities.Collection);
      API = {
        getReports: function() {
          var reports;
          reports = new Entities.ReportsCollection;
          reports.fetch({
            reset: true
          });
          return reports;
        },
        getReport: function(id) {
          var report;
          report = new Entities.Report({
            id: id
          });
          report.fetch();
          return report;
        },
        newReport: function(attributes) {
          if (attributes == null) {
            attributes = {};
          }
          return new Entities.Report(attributes);
        }
      };
      App.reqres.setHandler("reports:entities", function() {
        return API.getReports;
      });
      App.reqres.setHandler("reports:entity", function(id) {
        return API.getReport(id);
      });
      return App.reqres.setHandler("new:reports:entity", function(attributes) {
        return API.newReport(attributes);
      });
    });
  });

}).call(this);
