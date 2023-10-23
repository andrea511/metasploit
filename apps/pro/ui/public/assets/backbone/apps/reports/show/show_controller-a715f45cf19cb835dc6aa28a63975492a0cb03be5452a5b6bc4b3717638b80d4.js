(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'entities/report_artifact', 'entities/report', 'apps/reports/show/show_view'], function() {
    return this.Pro.module("ReportsApp.Show", function(Show, App) {
      var API;
      Show.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.initialize = function(options) {
          var id, report, reportArtifacts, selectedReportArtifact,
            _this = this;
          report = options.report, id = options.id, reportArtifacts = options.reportArtifacts;
          report || (report = App.request('report:entity', id));
          reportArtifacts || (reportArtifacts = App.request('report_artifacts:entities'));
          selectedReportArtifact = App.request('report:formats:next', reportArtifacts);
          this.listenTo(report, 'updated', function() {
            return App.vent.trigger('report:updated', report);
          });
          this.layout = this.getLayoutView();
          this.listenTo(this.layout, "show", function() {
            _this.headerRegion(report);
            _this.infoRegion(report);
            _this.formatsRegion(report, reportArtifacts);
            _this.actionsRegion();
            return _this.displayRegion(selectedReportArtifact, reportArtifacts);
          });
          return this.show(this.layout);
        };

        Controller.prototype.showReportArtifact = function(reportArtifact) {
          this.layout.displayRegion.reset();
          return this.displayRegion(reportArtifact);
        };

        Controller.prototype.headerRegion = function(report) {
          var headerView;
          headerView = this.getHeaderView(report);
          return this.layout.headerRegion.show(headerView);
        };

        Controller.prototype.infoRegion = function(report) {
          var infoView;
          infoView = this.getInfoView(report);
          return this.layout.infoRegion.show(infoView);
        };

        Controller.prototype.formatsRegion = function(report, reportArtifacts) {
          var formatsView;
          formatsView = this.getFormatsView(report, reportArtifacts);
          return this.layout.formatsRegion.show(formatsView);
        };

        Controller.prototype.actionsRegion = function() {
          var actionsView;
          actionsView = this.getActionsView();
          return this.layout.actionsRegion.show(actionsView);
        };

        Controller.prototype.displayRegion = function(reportArtifactToDisplay, reportArtifacts) {
          var displayView;
          displayView = this.getDisplayView(reportArtifactToDisplay, reportArtifacts);
          return this.layout.displayRegion.show(displayView);
        };

        Controller.prototype.getLayoutView = function() {
          return new Show.Layout;
        };

        Controller.prototype.getHeaderView = function(report) {
          return new Show.Header({
            model: report
          });
        };

        Controller.prototype.getInfoView = function(report) {
          return new Show.Info({
            model: report
          });
        };

        Controller.prototype.getFormatsView = function(report, reportArtifacts) {
          return new Show.Formats({
            collection: reportArtifacts,
            report: report
          });
        };

        Controller.prototype.getActionsView = function() {
          return new Show.Actions;
        };

        Controller.prototype.getDisplayView = function(reportArtifact, reportArtifacts) {
          return new Show.Display({
            model: reportArtifact,
            reportArtifacts: reportArtifacts
          });
        };

        return Controller;

      })(App.Controllers.Application);
      API = {
        selectedFormatCheckboxes: function() {
          return Pro.mainRegion.currentView.formatsRegion.currentView.selectedFormats();
        },
        regeneratingFormats: function() {
          return Pro.mainRegion.currentView.formatsRegion.currentView.regeneratingFormats();
        },
        displayReportArtifact: function(reportArtifact, reportArtifacts) {
          var displayView;
          Pro.mainRegion.currentView.displayRegion.reset();
          displayView = new Show.Display({
            model: reportArtifact,
            reportArtifacts: reportArtifacts
          });
          return Pro.mainRegion.currentView.displayRegion.show(displayView);
        },
        nextFormatToDisplay: function(reportArtifacts) {
          var getNextArtifact, initialArtifact;
          getNextArtifact = function() {
            var html, pdf, rtf, word;
            if (pdf = reportArtifacts.findWhere({
              file_format: 'pdf',
              not_generated: false
            })) {
              return pdf;
            }
            if (html = reportArtifacts.findWhere({
              file_format: 'html',
              not_generated: false
            })) {
              return html;
            }
            if (rtf = reportArtifacts.findWhere({
              file_format: 'rtf',
              not_generated: false
            })) {
              return rtf;
            }
            if (word = reportArtifacts.findWhere({
              file_format: 'word',
              not_generated: false
            })) {
              return word;
            }
          };
          initialArtifact = getNextArtifact();
          if (initialArtifact) {
            initialArtifact.set('displayed', true);
          }
          return initialArtifact;
        }
      };
      App.reqres.setHandler('report:formats:selected', API.selectedFormatCheckboxes);
      App.reqres.setHandler('report:formats:regenerating', API.regeneratingFormats);
      App.commands.setHandler('report:formats:display', function(reportArtifact, reportArtifacts) {
        App.vent.trigger('report:formats:displayed', reportArtifact);
        return API.displayReportArtifact(reportArtifact, reportArtifacts);
      });
      return App.reqres.setHandler('report:formats:next', API.nextFormatToDisplay);
    });
  });

}).call(this);
