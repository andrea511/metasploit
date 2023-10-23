(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['jquery', 'base_view', 'base_itemview', 'base_layout', 'base_compositeview', 'apps/reports/show/templates/_file_format', 'apps/reports/show/templates/show_actions', 'apps/reports/show/templates/show_display', 'apps/reports/show/templates/show_email_form', 'apps/reports/show/templates/show_formats', 'apps/reports/show/templates/show_header', 'apps/reports/show/templates/show_info', 'apps/reports/show/templates/show_info_dialog', 'apps/reports/show/templates/show_layout', 'apps/reports/preload_images', 'entities/report_artifact', 'entities/report'], function($) {
    return this.Pro.module('ReportsApp.Show', function(Show, App, Backbone, Marionette, jQuery, _) {
      Show.Layout = (function(_super) {

        __extends(Layout, _super);

        function Layout() {
          return Layout.__super__.constructor.apply(this, arguments);
        }

        Layout.prototype.template = Layout.prototype.templatePath('reports/show/show_layout');

        Layout.prototype.regions = {
          headerRegion: '#report-header-region',
          infoRegion: '#report-info-region',
          formatsRegion: '#report-formats-region',
          actionsRegion: '#report-actions-region',
          displayRegion: '#report-display-region'
        };

        return Layout;

      })(App.Views.Layout);
      Show.Header = (function(_super) {

        __extends(Header, _super);

        function Header() {
          return Header.__super__.constructor.apply(this, arguments);
        }

        Header.prototype.template = Header.prototype.templatePath('reports/show/show_header');

        return Header;

      })(App.Views.ItemView);
      Show.Info = (function(_super) {

        __extends(Info, _super);

        function Info() {
          return Info.__super__.constructor.apply(this, arguments);
        }

        Info.prototype.template = Info.prototype.templatePath('reports/show/show_info');

        Info.prototype.className = 'info-wrapper';

        Info.prototype.events = {
          'click #report-info-button': 'showReportInfo'
        };

        Info.prototype.showReportInfo = function() {
          return this.showDialog(new Show.InfoDialog({
            model: this.model
          }), {
            title: 'Report Information',
            "class": 'report-info-dialog',
            buttons: [
              {
                name: 'Close',
                "class": 'close'
              }
            ]
          });
        };

        return Info;

      })(App.Views.ItemView);
      Show.InfoDialog = (function(_super) {

        __extends(InfoDialog, _super);

        function InfoDialog() {
          return InfoDialog.__super__.constructor.apply(this, arguments);
        }

        InfoDialog.prototype.template = InfoDialog.prototype.templatePath('reports/show/show_info_dialog');

        return InfoDialog;

      })(App.Views.ItemView);
      Show.Format = (function(_super) {

        __extends(Format, _super);

        function Format() {
          this.onDestroy = __bind(this.onDestroy, this);

          this.stopPoll = __bind(this.stopPoll, this);

          this.poll = __bind(this.poll, this);
          return Format.__super__.constructor.apply(this, arguments);
        }

        Format.prototype.template = Format.prototype.templatePath('reports/show/_file_format');

        Format.prototype.tagName = 'li';

        Format.prototype.className = 'file-format';

        Format.prototype.ui = {
          regenerate_button: '.regenerate-button',
          format_button: '.format-button'
        };

        Format.prototype.events = {
          'click @ui.regenerate_button': 'regenerateFormat',
          'click @ui.format_button': 'handleFormatClick'
        };

        Format.prototype.modelEvents = {
          'change': 'render'
        };

        Format.prototype.handleFormatClick = function() {
          if (!(this.model.get('displayed') || this.model.get('not_generated'))) {
            return App.execute('report:formats:display', this.model);
          }
        };

        Format.prototype.regenerateFormat = function() {
          var file_format, regeneratingFormat,
            _this = this;
          if (this.model.get('artifact_file_exists')) {
            return alert('Please delete existing report type before generating');
          } else if (!this.model.get('artifact_file_exists') && !this.model.get('not_generated')) {
            return alert('Report artifact not found on filesystem. Please delete this format and regenerate it.');
          } else if (!this.model.regenerating()) {
            regeneratingFormat = App.request('report:formats:regenerating');
            if (regeneratingFormat) {
              alert("Please wait until the " + (regeneratingFormat.get('file_format')) + " format is done generating.");
              return false;
            }
            this.model.set('status', 'regenerating');
            App.vent.trigger('report:formats:regenerating', this.model);
            this.addTooltip();
            file_format = this.model.get('file_format');
            return $.ajax({
              url: gon.regenerate_format_path,
              type: 'POST',
              data: {
                file_format: file_format
              },
              success: function() {
                return _this.poll();
              },
              error: function() {
                return _this.model.set('status', 'error');
              }
            });
          }
        };

        Format.prototype.pollingInterval = 5000;

        Format.prototype.poll = function() {
          var fetchStatus,
            _this = this;
          fetchStatus = function() {
            var file_format;
            file_format = _this.model.get('file_format');
            return $.ajax({
              url: gon.regeneration_status_path,
              type: 'POST',
              data: {
                file_format: file_format
              },
              success: function(data) {
                if (data.status === 'complete') {
                  _this.model.set(data);
                  _this.addTooltip();
                  return App.vent.trigger('report:formats:regenerated', _this.model);
                } else {
                  _this.model.set('status', data.status);
                  return _this._poller = setTimeout((function() {
                    return fetchStatus();
                  }), _this.pollingInterval);
                }
              },
              error: function() {
                return _this.model.set('status', 'error');
              }
            });
          };
          return fetchStatus();
        };

        Format.prototype.startPoll = function() {
          if (this.model.regenerating()) {
            return this.poll();
          }
        };

        Format.prototype.stopPoll = function() {
          return clearTimeout(this._poller);
        };

        Format.prototype.addTooltip = function() {
          var tip;
          if (this.model.regenerating()) {
            return this.ui.format_button.tooltip({
              content: 'Regenerating.'
            });
          } else if (this.model.get('not_generated')) {
            return this.ui.format_button.tooltip({
              content: 'Not yet generated.'
            });
          } else if (!this.model.get('artifact_file_exists')) {
            return this.ui.format_button.tooltip({
              content: 'Error finding report artifact on filesystem. '
            });
          } else {
            tip = "Created " + (this.model.get('pretty_created_at'));
            if (this.model.get('pretty_accessed_at')) {
              tip += "<br />Accessed " + (this.model.get('pretty_accessed_at'));
            }
            return this.ui.format_button.tooltip({
              content: tip
            });
          }
        };

        Format.prototype.onDestroy = function() {
          return this.stopPoll();
        };

        Format.prototype.onShow = function() {
          this.startPoll();
          return this.addTooltip();
        };

        return Format;

      })(App.Views.ItemView);
      Show.Formats = (function(_super) {

        __extends(Formats, _super);

        function Formats() {
          this.selectedFormats = __bind(this.selectedFormats, this);

          this.handleFormatDestruction = __bind(this.handleFormatDestruction, this);

          this.regeneratingFormats = __bind(this.regeneratingFormats, this);
          return Formats.__super__.constructor.apply(this, arguments);
        }

        Formats.prototype.template = Formats.prototype.templatePath('reports/show/show_formats');

        Formats.prototype.childView = Show.Format;

        Formats.prototype.childViewContainer = 'ul';

        Formats.prototype.className = 'info-wrapper';

        Formats.prototype.initialize = function(options) {
          var _this = this;
          App.vent.on('report:formats:destroyed', function(reportArtifact) {
            return _this.handleFormatDestruction(reportArtifact);
          });
          App.vent.on('report:formats:displayed', function(reportArtifact) {
            return _this.handleArtifactDisplay(reportArtifact);
          });
          this.report = options.report;
          return Formats.__super__.initialize.call(this, options);
        };

        Formats.prototype.regeneratingFormats = function() {
          return this.collection.findWhere({
            status: 'regenerating'
          });
        };

        Formats.prototype.handleFormatDestruction = function(reportArtifact) {
          var nextArtifact;
          this.render();
          if (reportArtifact.get('displayed')) {
            nextArtifact = App.request('report:formats:next', this.collection);
            return App.execute('report:formats:display', nextArtifact, this.collection);
          } else if (this.collection.where({
            not_generated: true
          }).size() === this.collection.size()) {
            return App.execute('report:formats:display', null, this.collection);
          }
        };

        Formats.prototype.handleArtifactDisplay = function(reportArtifact) {
          var displayed;
          if (reportArtifact) {
            displayed = this.collection.findWhere({
              displayed: true
            });
            if (displayed) {
              displayed.set({
                displayed: false
              });
            }
            return reportArtifact.set('displayed', true);
          }
        };

        Formats.prototype.selectedFormats = function() {
          var currentlySelectedFormats;
          currentlySelectedFormats = [];
          this.children.each(function(formatView) {
            if (formatView.$el.find('input[type=checkbox]').prop('checked')) {
              return currentlySelectedFormats.push(formatView.model);
            }
          });
          return currentlySelectedFormats;
        };

        Formats.prototype.allReportFormats = function() {
          var regeneratingFormats, reportArtifactsAndFormats,
            _this = this;
          reportArtifactsAndFormats = new App.Entities.ReportArtifactsCollection;
          _.each(this.report.get('allowed_file_formats'), function(format) {
            var existingArtifact;
            existingArtifact = _this.collection.where({
              file_format: format
            });
            if (existingArtifact.size() > 0) {
              existingArtifact = existingArtifact.first();
              if (!(existingArtifact.get('artifact_file_exists') || existingArtifact.get('not_generated'))) {
                existingArtifact.set('status', 'error');
              }
              return reportArtifactsAndFormats.add(existingArtifact);
            } else {
              return reportArtifactsAndFormats.add({
                file_format: format,
                not_generated: true
              });
            }
          });
          if (this.report.get('state') === 'regenerating') {
            regeneratingFormats = this.report.get('file_formats');
            _.each(regeneratingFormats, function(fileFormat) {
              var regeneratingArtifact;
              regeneratingArtifact = new App.Entities.ReportArtifact({
                file_format: fileFormat,
                status: 'regenerating'
              });
              reportArtifactsAndFormats.remove(reportArtifactsAndFormats.findWhere({
                file_format: fileFormat
              }));
              return reportArtifactsAndFormats.add(regeneratingArtifact);
            });
          }
          return reportArtifactsAndFormats;
        };

        Formats.prototype.onBeforeRender = function() {
          return this.collection = this.allReportFormats();
        };

        return Formats;

      })(App.Views.CompositeView);
      Show.Actions = (function(_super) {

        __extends(Actions, _super);

        function Actions() {
          this.destroyReportArtifacts = __bind(this.destroyReportArtifacts, this);
          return Actions.__super__.constructor.apply(this, arguments);
        }

        Actions.prototype.template = Actions.prototype.templatePath('reports/show/show_actions');

        Actions.prototype.className = 'info-wrapper';

        Actions.prototype.events = {
          'click #download-report': 'downloadReportArtifact',
          'click #destroy-report': 'destroyReportArtifacts',
          'click #email-report': 'emailReportArtifacts'
        };

        Actions.prototype.downloadReportArtifact = function() {
          var selectedFormats;
          selectedFormats = App.request('report:formats:selected');
          switch (false) {
            case selectedFormats.size() !== 0:
              return alert('Please select a report format to download.');
            case !(selectedFormats.size() > 1):
              return alert('Please select a single report format for downloading.');
            default:
              return $('<iframe/>').attr({
                src: selectedFormats[0].get('download_url'),
                style: 'display: none;'
              }).appendTo(this.$el);
          }
        };

        Actions.prototype.destroyReportArtifacts = function() {
          var selectedFormats, selectedFormatsIndicator;
          selectedFormats = App.request('report:formats:selected');
          if (selectedFormats.size() === 0) {
            alert('Please select at least one report format to destroy.');
            return false;
          } else if (selectedFormats.size() === 1) {
            selectedFormatsIndicator = 'format';
          } else if (selectedFormats.size() > 1) {
            selectedFormatsIndicator = 'formats';
          }
          if (confirm("Are you sure you want to destroy the selected " + selectedFormatsIndicator + "?")) {
            return _.each(selectedFormats, function(format) {
              format.destroy({
                silent: true
              });
              return App.vent.trigger('report:formats:destroyed', format);
            });
          }
        };

        Actions.prototype.emailReportArtifacts = function() {
          var selectedFormats;
          selectedFormats = App.request('report:formats:selected');
          if (selectedFormats.size() === 0) {
            alert('Please select at least one report format to email.');
            return false;
          }
          return this.showDialog(new Show.EmailForm, {
            title: 'Email Report',
            height: 200,
            "class": 'report-email-dialog',
            buttons: [
              {
                name: 'Cancel',
                "class": 'close'
              }, {
                name: 'Send',
                "class": 'btn primary'
              }
            ]
          });
        };

        return Actions;

      })(App.Views.ItemView);
      Show.EmailForm = (function(_super) {

        __extends(EmailForm, _super);

        function EmailForm() {
          return EmailForm.__super__.constructor.apply(this, arguments);
        }

        EmailForm.prototype.template = EmailForm.prototype.templatePath('reports/show/show_email_form');

        EmailForm.prototype.ui = {
          reportEmailAddressesTextarea: '#report-email-addresses'
        };

        EmailForm.prototype.onDialogButtonPrimaryClicked = function() {
          return this.sendEmail();
        };

        EmailForm.prototype.sendEmail = function() {
          var emailAddresses, reportArtifactIDs, selectedFormats;
          emailAddresses = this.ui.reportEmailAddressesTextarea.val();
          selectedFormats = App.request('report:formats:selected');
          reportArtifactIDs = _.collect(selectedFormats, function(format) {
            return format.id;
          });
          return $.post(gon.email_report_artifacts_path, {
            recipients: emailAddresses,
            report_artifact_ids: reportArtifactIDs
          });
        };

        return EmailForm;

      })(App.Views.ItemView);
      return Show.Display = (function(_super) {

        __extends(Display, _super);

        function Display() {
          return Display.__super__.constructor.apply(this, arguments);
        }

        Display.prototype.template = Display.prototype.templatePath('reports/show/show_display');

        Display.prototype.ui = {
          displayPanel: '#report-display-panel',
          messages: '.report-display-panel-message',
          unembeddableMessage: '#unembeddable-message',
          noArtifactsMessage: '#no-artifacts-message',
          brokenArtifactMessage: '#broken-artifact-message'
        };

        Display.prototype.initialize = function(options) {
          this.reportArtifacts = options.reportArtifacts;
          return Display.__super__.initialize.call(this, options);
        };

        Display.prototype.displayArtifact = function() {
          if (this.reportArtifacts && (this.reportArtifacts.size() === 0 || this.reportArtifacts.where({
            not_generated: true
          }).size() === this.reportArtifacts.size())) {
            return this.ui.noArtifactsMessage.css('display', 'table');
          } else if (!this.model.get('artifact_file_exists')) {
            return this.ui.brokenArtifactMessage.css('display', 'table');
          } else {
            this.ui.messages.hide();
            switch (this.model.get('file_format')) {
              case 'pdf':
                return this.displayPDF();
              case 'html':
                return this.displayHTML();
              case 'rtf':
                return this.ui.unembeddableMessage.css('display', 'table');
              case 'word':
                return this.ui.unembeddableMessage.css('display', 'table');
            }
          }
        };

        Display.prototype.displayHTML = function() {
          return this.$el.html("<iframe src='" + (this.model.get('url')) + "' seamless='seamless'></iframe>");
        };

        Display.prototype.displayPDF = function() {
          var pdfEmbed;
          pdfEmbed = "        <object width=\"100%\" height=\"100%\" type=\"application/pdf\" data=\"" + (this.model.get('url')) + "\" id=\"pdf\">          <div id=\"report-pdf-embed-error-message\" class=\"report-display-panel-message\">            <p>It appears you don't have Adobe Reader or PDF support in this web browser.            <a href=\"" + (this.model.get('download_url')) + "\">Click here to download the PDF.</a></p>          </div>       </object>";
          return this.ui.displayPanel.append(pdfEmbed);
        };

        Display.prototype.onShow = function() {
          return this.displayArtifact();
        };

        return Display;

      })(App.Views.ItemView);
    });
  });

}).call(this);
