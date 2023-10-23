(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/task_chains/item_views/task_chain_header-b0ebc32c46e55e016b066c8422dbf654d7716f80f2a7b6946c2d09259eab75db.js', '/assets/shared/backbone/layouts/modal-57927538cf64c26b47a2f8f54fdef926ef3c906fba72986d69e71e13cfe4422f.js', '/assets/task_chains/backbone/views/layouts/scheduler_layout-0ad06cfe97861da537ee99efed49b96f81d78f486b6a90be1766f10275447e3d.js'], function($, Template, Modal, SchedulerLayout) {
    var TaskChainHeader;
    return TaskChainHeader = (function(_super) {

      __extends(TaskChainHeader, _super);

      function TaskChainHeader() {
        this._closeSchedule = __bind(this._closeSchedule, this);
        return TaskChainHeader.__super__.constructor.apply(this, arguments);
      }

      TaskChainHeader.prototype.template = HandlebarsTemplates['task_chains/item_views/task_chain_header'];

      TaskChainHeader.prototype.ui = {
        save_buttons: '.btn.save-run, .btn.save',
        save_links: '.btn.save-run a, .btn.save a',
        save_list_items: '.save-and-run, .save',
        task_chain_name: '#name',
        schedule: 'a.schedule',
        schedule_state: '.schedule-state'
      };

      TaskChainHeader.prototype.events = {
        'click .btn.cancel': '_cancel',
        'click .btn.save a': '_saveChain',
        'click .btn.save-run a': '_saveChainAndRun',
        'click a.schedule': '_scheduleTask'
      };

      TaskChainHeader.prototype.onShow = function() {
        this.schedule_has_been_opened = false;
        this._bindTriggers();
        if (this.cachedSchedule == null) {
          return this.cachedSchedule = new SchedulerLayout({
            model: this.model
          });
        }
      };

      TaskChainHeader.prototype.onDestroy = function() {
        this._unbindTriggers();
        return gon.unwatch('taskChainRunning', this.preventDoubleStart);
      };

      TaskChainHeader.prototype._bindTriggers = function() {
        $(document).on('closeSchedule', this._closeSchedule);
        return $(document).on('modal.button.close', this._cancelSchedule);
      };

      TaskChainHeader.prototype._unbindTriggers = function() {
        $(document).off('closeSchedule', this._closeSchedule);
        return $(document).off('modal.button.close', this._cancelSchedule);
      };

      TaskChainHeader.prototype._saveChain = function() {
        return $(this.el).trigger('saveChain');
      };

      TaskChainHeader.prototype._cancel = function() {
        return window.location = "/workspaces/" + WORKSPACE_ID + "/task_chains";
      };

      TaskChainHeader.prototype._saveChainAndRun = function() {
        return $(this.el).trigger('saveChainAndRun');
      };

      TaskChainHeader.prototype._scheduleTask = function() {
        var _ref;
        if (this.schedule_has_been_opened) {
          this.cachedSchedule = new SchedulerLayout({
            model: this.model
          });
        }
        this.schedule_has_been_opened = true;
        this.modal = new Modal({
          title: 'Schedule a Task Chain',
          width: 710,
          buttons: [
            {
              name: 'Close',
              "class": 'close'
            }, {
              name: 'Save',
              "class": 'btn primary'
            }
          ]
        });
        this.modal.open();
        if ((_ref = this.model.currentView) != null) {
          _ref.close();
        }
        return this.modal.content.show(this.cachedSchedule, {
          preventDestroy: true,
          forceShow: true
        });
      };

      TaskChainHeader.prototype._renderToolTip = function(toolTipMsg) {
        if (toolTipMsg != null) {
          return this.ui.save_list_items.each(function() {
            return $(this).tooltip({
              items: 'span',
              content: _.escape(toolTipMsg),
              disabled: false
            });
          });
        } else {
          return this.ui.save_list_items.each(function() {
            return $(this).tooltip({
              items: 'span',
              disabled: true
            });
          });
        }
      };

      TaskChainHeader.prototype.setName = function(name) {
        return this.ui.task_chain_name.val(name);
      };

      TaskChainHeader.prototype.disableSave = function(opts) {
        var toolTipMsg;
        if (opts == null) {
          opts = {};
        }
        toolTipMsg = opts.toolTipMsg;
        this._renderToolTip(toolTipMsg);
        this.ui.save_buttons.addClass('disabled');
        return this.ui.save_links.addClass('disabled');
      };

      TaskChainHeader.prototype.enableSave = function(opts) {
        var toolTipMsg;
        if (opts == null) {
          opts = {};
        }
        toolTipMsg = opts.toolTipMsg;
        this._renderToolTip(toolTipMsg);
        this.ui.save_buttons.removeClass('disabled');
        return this.ui.save_links.removeClass('disabled');
      };

      TaskChainHeader.prototype.setScheduleInfo = function(run_info) {
        if (run_info === "") {
          run_info = "Schedule Now";
        }
        return this.ui.schedule.html(run_info);
      };

      TaskChainHeader.prototype.setState = function(task_chain) {
        if (task_chain.schedule_info.indexOf("Invalid") === -1 && task_chain.schedule_info !== "" && task_chain.state !== 'suspended') {
          if (task_chain.schedule_info.indexOf("at") === -1) {
            return this.setRecurringState();
          } else {
            return this.setScheduledState();
          }
        } else {
          if (task_chain.state === 'suspended') {
            return this.setSuspendedState();
          } else {
            return this.setUnscheduledState();
          }
        }
      };

      TaskChainHeader.prototype.setRecurringState = function() {
        this._clearState();
        return this.ui.schedule_state.addClass('recurring');
      };

      TaskChainHeader.prototype.setScheduledState = function() {
        this._clearState();
        return this.ui.schedule_state.addClass('scheduled');
      };

      TaskChainHeader.prototype.setSuspendedState = function() {
        this._clearState();
        return this.ui.schedule_state.addClass('suspended');
      };

      TaskChainHeader.prototype.setUnscheduledState = function() {
        this._clearState();
        return this.ui.schedule_state.addClass('schedule');
      };

      TaskChainHeader.prototype._clearState = function() {
        this.ui.schedule_state.removeClass('recurring');
        this.ui.schedule_state.removeClass('scheduled');
        this.ui.schedule_state.removeClass('schedule');
        return this.ui.schedule_state.removeClass('suspended');
      };

      TaskChainHeader.prototype._closeSchedule = function() {
        var run_info, suspended;
        this.cachedSchedule.restoreSchedule = this.cachedSchedule.cachedView;
        run_info = $('.run-info', this.modal.el).html();
        suspended = $('.schedule-options input[name="schedule_suspend"]:checked', this.modal.el).length > 0;
        if (run_info.indexOf("Invalid") === -1 && !suspended) {
          this.setScheduleInfo(run_info);
          if (run_info.indexOf("at") === -1) {
            this.setRecurringState();
          } else {
            this.setScheduledState();
          }
        } else {
          this.setScheduleInfo('Schedule');
          this.setSuspendedState();
        }
        return this.modal._close();
      };

      return TaskChainHeader;

    })(Backbone.Marionette.ItemView);
  });

}).call(this);
