(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_model', 'base_collection'], function() {
    return this.Pro.module("Entities", function(Entities, App) {
      var API;
      Entities.ReportArtifact = (function(_super) {

        __extends(ReportArtifact, _super);

        function ReportArtifact() {
          return ReportArtifact.__super__.constructor.apply(this, arguments);
        }

        ReportArtifact.prototype.regenerating = function() {
          return this.get('status') === 'regenerating';
        };

        return ReportArtifact;

      })(App.Entities.Model);
      Entities.ReportArtifactsCollection = (function(_super) {

        __extends(ReportArtifactsCollection, _super);

        function ReportArtifactsCollection() {
          return ReportArtifactsCollection.__super__.constructor.apply(this, arguments);
        }

        ReportArtifactsCollection.prototype.model = Entities.ReportArtifact;

        ReportArtifactsCollection.prototype.comparator = function(artifact) {
          return artifact.get('file_format');
        };

        ReportArtifactsCollection.prototype.formats = function() {
          return _.collect(this.models, function(artifact) {
            return artifact.get('file_format');
          });
        };

        ReportArtifactsCollection.prototype.url = gon.report_artifacts_path;

        return ReportArtifactsCollection;

      })(App.Entities.Collection);
      API = {
        getReportArtifacts: function() {
          var reportArtifacts;
          reportArtifacts = new Entities.ReportArtifactsCollection;
          reportArtifacts.fetch({
            reset: true
          });
          return reportArtifacts;
        },
        getReportArtifact: function(id) {
          var reportArtifact;
          reportArtifact = new Entities.ReportArtifact({
            id: id
          });
          reportArtifact.fetch();
          return reportArtifact;
        },
        newReportArtifact: function(attributes) {
          if (attributes == null) {
            attributes = {};
          }
          return new Entities.ReportArtifact(attributes);
        },
        newReportArtifacts: function(entities) {
          if (entities == null) {
            entities = [];
          }
          return new Entities.ReportArtifactsCollection(entities);
        }
      };
      App.reqres.setHandler("report_artifacts:entities", function() {
        return API.getReportArtifacts;
      });
      App.reqres.setHandler("report_artifacts:entity", function(id) {
        return API.getReportArtifact(id);
      });
      App.reqres.setHandler("new:report_artifact:entity", function(attributes) {
        return API.newReportArtifact(attributes);
      });
      return App.reqres.setHandler("new:report_artifacts:entities", function(entities) {
        return API.newReportArtifacts(entities);
      });
    });
  });

}).call(this);
