(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_layout', 'base_view', 'base_itemview', 'lib/shared/nexpose_push/templates/push_modal_layout', 'lib/shared/nexpose_push/templates/push_modal_no_console'], function() {
    return this.Pro.module('Shared.NexposePush', function(NexposePush, App, Backbone, Marionette, $, _) {
      NexposePush.ButtonView = (function(_super) {

        __extends(ButtonView, _super);

        function ButtonView() {
          return ButtonView.__super__.constructor.apply(this, arguments);
        }

        ButtonView.prototype.template = function() {
          return "Push to Nexpose";
        };

        ButtonView.prototype.onRowsSelected = function(tableSelections) {
          var _this = this;
          this.selectAllState = tableSelections.selectAllState || null;
          this.selectedIDs = _.map(tableSelections.selectedIDs, function(val, id) {
            return parseInt(id);
          });
          this.deselectedIDs = _.map(tableSelections.deselectedIDs, function(val, id) {
            return parseInt(id);
          });
          return jQuery.ajax({
            url: Routes.push_to_nexpose_status_workspace_vulns_path({
              workspace_id: WORKSPACE_ID
            }),
            type: 'GET',
            data: {
              selections: {
                select_all_state: this.selectAllState,
                selected_ids: this.selectedIDs,
                deselected_ids: this.deselectedIDs
              },
              ignore_pagination: true
            },
            success: function(data) {
              _this._currentStatus = data.status;
              if (data.status) {
                _this.enableButton(data.reason);
              } else {
                _this.disableButton(data.reason);
              }
              return _this.setTooltip(data.reason);
            },
            error: function(data) {
              throw "Error with push_to_nexpose_status endpoint";
            }
          });
        };

        ButtonView.prototype.getStatus = function() {
          return this._currentStatus;
        };

        ButtonView.prototype.disableButton = function(reason) {
          return this.$el.parent().addClass('disabled');
        };

        ButtonView.prototype.enableButton = function(reason) {
          return this.$el.parent().removeClass('disabled');
        };

        ButtonView.prototype.setTooltip = function(reason) {
          this.$el.parent().attr('title', reason);
          return this.$el.parent().tooltip();
        };

        return ButtonView;

      })(App.Views.ItemView);
      return NexposePush.ModalView = (function(_super) {

        __extends(ModalView, _super);

        function ModalView() {
          return ModalView.__super__.constructor.apply(this, arguments);
        }

        ModalView.prototype.initialize = function() {
          return this.template = this.model.get('has_console_enabled') ? this.templatePath('nexpose_push/push_modal_layout') : this.templatePath('nexpose_push/push_modal_no_console');
        };

        ModalView.prototype.className = 'push-view';

        ModalView.prototype.ui = {
          datetime: '.datetime'
        };

        ModalView.prototype.onShow = function() {
          return this.ui.datetime.datepicker({
            minDate: 1
          });
        };

        ModalView.prototype.onBeforeDestroy = function() {
          return this.ui.datetime.datepicker('destroy');
        };

        return ModalView;

      })(App.Views.Layout);
    });
  });

}).call(this);
