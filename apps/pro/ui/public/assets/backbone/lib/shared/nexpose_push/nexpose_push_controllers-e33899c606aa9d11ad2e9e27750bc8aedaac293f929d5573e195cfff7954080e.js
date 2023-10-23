(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['entities/vuln', 'base_controller', 'apps/vulns/vulns_app', 'entities/nexpose/exception', 'apps/vulns/index/index_views', 'lib/components/modal/modal_controller', 'lib/concerns/controllers/table_selections', 'lib/components/analysis_tab/analysis_tab_controller', 'lib/shared/nexpose_push/nexpose_push_started_controller'], function() {
    return this.Pro.module("Shared.NexposePush", function(NexposePush, App, Backbone, Marionette, $, _) {
      NexposePush.ButtonController = (function(_super) {

        __extends(ButtonController, _super);

        function ButtonController() {
          return ButtonController.__super__.constructor.apply(this, arguments);
        }

        ButtonController.prototype.initialize = function(opts) {
          var vulns;
          _.defaults(opts, {
            redirectToTaskLog: false
          });
          this.redirectToTaskLog = opts.redirectToTaskLog;
          return vulns = App.request('vulns:entities', {
            fetch: false
          });
        };

        ButtonController.prototype.getButton = function() {
          var redirectToTaskLog,
            _this = this;
          redirectToTaskLog = this.redirectToTaskLog;
          return {
            label: 'Push to Nexpose',
            "class": 'nexpose nexpose-push disabled',
            click: function(selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) {
              var request_message;
              if (!(jQuery("a.nexpose-push").hasClass("disabled"))) {
                request_message = jQuery.ajax({
                  url: Routes.push_to_nexpose_message_workspace_vulns_path({
                    workspace_id: WORKSPACE_ID
                  }),
                  type: 'GET',
                  selections: {
                    selectAllState: selectAllState,
                    selectedIDs: selectedIDs,
                    deselectedIDs: deselectedIDs,
                    selectedVisibleCollection: selectedVisibleCollection,
                    tableCollection: tableCollection
                  },
                  data: {
                    selections: {
                      select_all_state: selectAllState || null,
                      selected_ids: selectedIDs,
                      deselected_ids: deselectedIDs
                    },
                    ignore_pagination: true
                  }
                });
                return request_message.then(function(data) {
                  var controller, opts;
                  opts = {
                    message: data.message,
                    has_console: data.has_console,
                    has_console_enabled: data.has_console_enabled,
                    has_validations: data.has_validations,
                    has_exceptions: data.has_exceptions,
                    selectAllState: this.selections.selectAllState,
                    selectedIDs: this.selections.selectedIDs,
                    deselectedIDs: this.selections.deselectedIDs,
                    tableCollection: this.selections.tableCollection,
                    selectedVisibleCollection: this.selections.selectedVisibleCollection,
                    redirectToTaskLog: redirectToTaskLog
                  };
                  controller = new App.Shared.NexposePush.ModalController(opts);
                  return controller.showModal();
                });
              }
            }
          };
        };

        return ButtonController;

      })(App.Controllers.Application);
      return NexposePush.ModalController = (function(_super) {

        __extends(ModalController, _super);

        function ModalController() {
          return ModalController.__super__.constructor.apply(this, arguments);
        }

        ModalController.include('TableSelections');

        ModalController.prototype.initialize = function(opts) {
          _.defaults(opts, {
            title: 'Push To Nexpose',
            pushButtonText: 'PUSH',
            redirectToTaskLog: false
          });
          this.selectAllState = opts.selectAllState, this.selectedIDs = opts.selectedIDs, this.deselectedIDs = opts.deselectedIDs, this.selectedVisibleCollection = opts.selectedVisibleCollection, this.tableCollection = opts.tableCollection, this.message = opts.message, this.has_console = opts.has_console, this.has_console_enabled = opts.has_console_enabled, this.has_validations = opts.has_validations, this.has_exceptions = opts.has_exceptions, this.title = opts.title, this.pushButtonText = opts.pushButtonText, this.redirectToTaskLog = opts.redirectToTaskLog;
          this._getButtons();
          return this.setMainView(this._getModalView());
        };

        ModalController.prototype._getButtons = function() {
          if (this.buttons) {
            return this.buttons;
          }
          this.buttons = [
            {
              name: 'Cancel',
              "class": 'close'
            }
          ];
          if (this.has_console_enabled) {
            return this.buttons.push({
              name: this.pushButtonText,
              "class": 'btn primary'
            });
          }
        };

        ModalController.prototype._getModalView = function() {
          this.options.reasons = App.Entities.Nexpose.Exception.REASON;
          return this.modalView = this.modalView || new NexposePush.ModalView({
            model: new Backbone.Model(this.options)
          });
        };

        ModalController.prototype.parseExceptionInfo = function() {
          var exception_info, param, _i, _len, _ref;
          exception_info = {};
          _ref = $("#exception-info").serializeArray();
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            param = _ref[_i];
            exception_info[param.name] = param.value;
          }
          return exception_info;
        };

        ModalController.prototype._disablePushButton = function() {
          return this.trigger('btn:disable:modal', this.pushButtonText);
        };

        ModalController.prototype.onFormSubmit = function() {
          var defer, exceptionInfo, formSubmit,
            _this = this;
          defer = $.Deferred();
          formSubmit = function() {};
          defer.promise(formSubmit);
          exceptionInfo = this.parseExceptionInfo();
          this._disablePushButton();
          jQuery.ajax({
            url: Routes.workspace_nexpose_result_export_runs_path({
              workspace_id: WORKSPACE_ID
            }),
            type: 'POST',
            data: {
              selections: {
                select_all_state: this.selectAllState || null,
                selected_ids: this.selectedIDs,
                deselected_ids: this.deselectedIDs
              },
              reason: exceptionInfo.reason,
              expiration_date: exceptionInfo.expiration_date,
              approve: exceptionInfo.approve,
              comments: exceptionInfo.comments,
              ignore_pagination: true
            },
            success: function(data) {
              defer.resolve();
              App.vent.trigger('vulns:push:completed');
              if (_this.redirectToTaskLog) {
                return window.location.href = data.redirect_url;
              } else {
                return _this._showPushStartedModal(data.redirect_url);
              }
            },
            error: function() {
              return App.execute('flash:display', {
                title: 'An error occurred',
                style: 'error',
                message: "There was a problem pushing the results to Nexpose."
              });
            }
          });
          return formSubmit;
        };

        ModalController.prototype.showModal = function() {
          var _this = this;
          return App.execute("showModal", this, {
            modal: {
              title: this.title,
              description: this.message,
              hideBorder: true,
              width: 400
            },
            closeCallback: function() {
              return _this.trigger("modal:close");
            },
            buttons: this.buttons
          }, function(data) {
            throw "Error with push_to_nexpose_message endpoint";
          });
        };

        ModalController.prototype._showPushStartedModal = function(redirectUrl) {
          var controller;
          controller = new App.Shared.NexposePush.StartedController({
            redirectUrl: redirectUrl
          });
          return controller.showModal();
        };

        return ModalController;

      })(App.Controllers.Application);
    });
  });

}).call(this);
