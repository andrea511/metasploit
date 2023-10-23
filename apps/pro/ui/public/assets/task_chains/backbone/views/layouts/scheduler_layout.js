(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/task_chains/layouts/scheduler-851445c242400d0ea38c6bb1baffbbd66766dfe80a31bf39277592bd8e9e81a8.js', '/assets/task_chains/backbone/views/item_views/scheduler/daily_schedule-8cb5541b3439cfe5d4c30972909e1490178edbc663533920d72e17597d5f6763.js', '/assets/task_chains/backbone/views/item_views/scheduler/monthly_schedule-340519e2f179233cdd9cd3dc2bb529e05a7968ea338105c87631f42967dbae29.js', '/assets/task_chains/backbone/views/item_views/scheduler/weekly_schedule-d9827958db0c9fff698b78c1d708bbee09eb603df230d6437aff396522d6cd35.js', '/assets/task_chains/backbone/views/item_views/scheduler/hourly_schedule-717c050a422dee6cdc3ac1447e0ab58eb29881268eece828b9417271564679ba.js', '/assets/task_chains/backbone/views/item_views/scheduler/once_schedule-27eaf1da29d8e7deb69bf2286475772b522b43981a446a3e419a3869b9bf34a1.js'], function($, Template, DailySchedule, MonthlySchedule, WeeklySchedule, HourlySchedule, OnceSchedule) {
    var SchedulerLayout;
    return SchedulerLayout = (function(_super) {

      __extends(SchedulerLayout, _super);

      function SchedulerLayout() {
        this._renderErrors = __bind(this._renderErrors, this);

        this._form_to_object = __bind(this._form_to_object, this);

        this._validateStartDateInfo = __bind(this._validateStartDateInfo, this);

        this._scheduleTypeChanged = __bind(this._scheduleTypeChanged, this);
        return SchedulerLayout.__super__.constructor.apply(this, arguments);
      }

      SchedulerLayout.prototype.template = HandlebarsTemplates['task_chains/layouts/scheduler'];

      SchedulerLayout.prototype.VALIDATION_URL = "/workspaces/" + WORKSPACE_ID + "/task_chains/validate_schedule";

      SchedulerLayout.prototype.ui = {
        schedule_info: '.schedule-info',
        run_info: '.run-info'
      };

      SchedulerLayout.prototype.events = {
        'scheduleChanged .schedule-options': '_scheduleTypeChanged',
        'input .schedule-options': '_changed',
        'change .schedule-options': '_changed',
        'select .schedule-options': '_changed',
        'toggleTitle .schedule-options': '_toggleTitle',
        'change .schedule-options [name="schedule_suspend"]': '_toggleEnabledEvent'
      };

      SchedulerLayout.prototype.regions = {
        scheduleOptions: '.schedule-options'
      };

      SchedulerLayout.prototype.initialize = function() {
        var frequency;
        if (this.cachedView == null) {
          if (this.model.get('task_chain') != null) {
            frequency = this.model.get('task_chain').schedule_hash != null ? this.model.get('task_chain').schedule_hash.frequency : null;
            this._showSchedule(frequency, this.model);
          } else if (this.model.get("scheduleCache") != null) {
            frequency = this.model.get('scheduleCache').schedule_hash.frequency;
            if (this.model.get('task_chain')) {
              this.model.get('task_chain').schedule_hash = this.model.get('scheduleCache').schedule_hash;
              this.model.get('task_chain').clear_workspace_before_run = this.model.get('scheduleCache').clear_workspace_before_run;
            } else {
              this.model.set('task_chain', this.model.get("scheduleCache"));
            }
            this._showSchedule(frequency, this.model);
          } else {
            this.cachedView = new DailySchedule();
          }
          return this.cachedView.$el.html(this.cachedView.template(this.model.attributes));
        }
      };

      SchedulerLayout.prototype.close = function() {
        if (typeof this.onBeforeClose === "function") {
          this.onBeforeClose();
        }
        if (typeof this.onClose === "function") {
          this.onClose();
        }
        return this.stopListening();
      };

      SchedulerLayout.prototype.onShow = function() {
        var frequency, opts;
        this.undelegateEvents();
        this.delegateEvents();
        this.bindUIElements();
        if (this.cachedView == null) {
          if (this.model.get('task_chain') != null) {
            frequency = this.model.get('task_chain').schedule_hash != null ? this.model.get('task_chain').schedule_hash.frequency : null;
            this._showSchedule(frequency, this.model);
          } else {
            this.cachedView = new DailySchedule();
          }
        }
        if (this.restoreSchedule != null) {
          this.cachedView = this.restoreSchedule;
        }
        if (this.cachedView.isDestroyed) {
          opts = {
            cachedEl: this.cachedView.cachedEl,
            restoreEl: this.cachedView.restoreEl,
            $el: this.cachedView.$el,
            el: this.cachedView.el
          };
          this.cachedView = new this.cachedView.constructor(opts);
        }
        this.restoreSchedule = this.cachedView;
        this.scheduleOptions.show(this.cachedView, {
          preventDestroy: true,
          forceShow: true
        });
        this._initTitle();
        return this._debouncedValidation = _.debounce(this._validateStartDateInfo, 300);
      };

      SchedulerLayout.prototype._scheduleTypeChanged = function(e, select) {
        var schedule_type;
        schedule_type = $(select).val();
        this._showSchedule(schedule_type, null);
        this.scheduleOptions.show(this.cachedView, {
          preventDestroy: true
        });
        return this._initTitle();
      };

      SchedulerLayout.prototype._showSchedule = function(schedule_type, task_config) {
        if (task_config == null) {
          task_config = new Backbone.Model({
            task_chain: {
              schedule: "exists"
            }
          });
        }
        switch (schedule_type) {
          case 'once':
            if (this.once_schedule == null) {
              this.once_schedule = new OnceSchedule({
                model: task_config
              });
            }
            return this.cachedView = this.once_schedule;
          case 'hourly':
            if (this.hourly_schedule == null) {
              this.hourly_schedule = new HourlySchedule({
                model: task_config
              });
            }
            return this.cachedView = this.hourly_schedule;
          case 'weekly':
            if (this.weekly_schedule == null) {
              this.weekly_schedule = new WeeklySchedule({
                model: task_config
              });
            }
            return this.cachedView = this.weekly_schedule;
          case 'daily':
            if (this.daily_schedule == null) {
              this.daily_schedule = new DailySchedule({
                model: task_config
              });
            }
            return this.cachedView = this.daily_schedule;
          case 'monthly':
            if (this.monthly_schedule == null) {
              this.monthly_schedule = new MonthlySchedule({
                model: task_config
              });
            }
            return this.cachedView = this.monthly_schedule;
          default:
            if (this.once_schedule == null) {
              this.once_schedule = new OnceSchedule({
                model: task_config
              });
            }
            return this.cachedView = this.once_schedule;
        }
      };

      SchedulerLayout.prototype._validateStartDateInfo = function() {
        var $form, data, opts,
          _this = this;
        $form = $('form', this.el);
        data = [
          {
            name: 'authenticity_token',
            value: $('meta[name=csrf-token]').attr('content')
          }
        ];
        this.scheduleData = $('input,select,textarea', $form).not(':file, [name="_method"][value="delete"] ').serializeArray();
        data = data.concat(this.scheduleData);
        opts = {
          type: 'POST',
          data: data
        };
        return $.ajax(this.VALIDATION_URL, opts).done(function(data) {
          $('.error', _this.el).remove();
          _this.model.set('scheduleCache', _this._form_to_object(_this.scheduleData));
          if (_this.model.get('task_chain') != null) {
            _this.model.get('task_chain').schedule_hash = _this.model.get('scheduleCache').schedule_hash;
            _this.model.get('task_chain').clear_workspace_before_run = _this.model.get('scheduleCache').clear_workspace_before_run;
          }
          _this.ui.run_info.html(data.schedule);
          return $('.modal-actions>a.primary').removeClass('disabled');
        }).error(function(data) {
          _this._renderErrors(data.responseJSON);
          if (data.responseJSON.schedule != null) {
            _this.ui.run_info.html(data.responseJSON.schedule);
          }
          if ($('.schedule-options input[name="schedule_suspend"]:checked').length === 0) {
            return $('.modal-actions>a.primary').addClass('disabled');
          }
        });
      };

      SchedulerLayout.prototype._form_to_object = function(formArray) {
        var cached_frequency, entry, k, my_grouped_data, new_key, prefix_key, schedule_object, task_chain_object, v, _i, _len;
        my_grouped_data = {};
        for (_i = 0, _len = formArray.length; _i < _len; _i++) {
          entry = formArray[_i];
          if (entry.name.endsWith('[]')) {
            new_key = entry.name.substring(0, entry.name.length - 2);
            if (my_grouped_data[new_key] == null) {
              my_grouped_data[new_key] = [];
            }
            my_grouped_data[new_key].push(entry.value);
          } else {
            my_grouped_data[entry.name] = entry.value;
          }
        }
        cached_frequency = my_grouped_data['schedule_recurrence[frequency]'];
        schedule_object = {
          frequency: cached_frequency
        };
        schedule_object[cached_frequency] = [];
        prefix_key = 'schedule_recurrence[' + cached_frequency + '][';
        for (k in my_grouped_data) {
          v = my_grouped_data[k];
          if (k.include(prefix_key)) {
            new_key = k.substring(prefix_key.length, k.length - 1);
            schedule_object[cached_frequency][new_key] = v;
          }
        }
        task_chain_object = {
          clear_workspace_before_run: my_grouped_data['task_chain[clear_workspace_before_run]'],
          schedule_hash: schedule_object
        };
        return task_chain_object;
      };

      SchedulerLayout.prototype._renderErrors = function(errors) {
        var _this = this;
        $('.error', this.el).remove();
        return _.each(errors, function(v, k) {
          var $msg, name;
          name = "[" + k + "]";
          $msg = $('<div />', {
            "class": 'error'
          }).text(v[0]);
          $("input[name$='" + name + "']", _this.el).addClass('invalid').before($msg);
          return $("input[name$='" + name + "[]']", _this.el).first().addClass('invalid').before($msg);
        });
      };

      SchedulerLayout.prototype._initTitle = function() {
        var toggle_button;
        toggle_button = this.scheduleOptions.currentView.ui.toggle_button;
        return this._toggleEnabled(toggle_button);
      };

      SchedulerLayout.prototype._toggleEnabledEvent = function(e) {
        return this._toggleEnabled($(e.target));
      };

      SchedulerLayout.prototype._changed = function(e) {
        if (!($(e.target).hasClass('ios-switch') || $(e.target).attr('name') === 'task_chain[clear_workspace_before_run]' || $(e.target).attr('id') === 'schedule_type')) {
          return this._debouncedValidation();
        }
      };

      SchedulerLayout.prototype._toggleEnabled = function($elem) {
        var $form;
        $form = $(':not(.skip-disable, .skip-disable * )', this.scheduleOptions.currentView.ui.form);
        if ($elem.prop('checked')) {
          this.ui.schedule_info.css('visibility', 'hidden');
          $form.css('opacity', '0.5');
          $form.css('pointer-events', 'none');
          return $('.modal-actions>a.primary').removeClass('disabled');
        } else {
          this.ui.schedule_info.css('visibility', 'visible');
          $form.css('opacity', '1');
          $form.css('pointer-events', 'auto');
          return this._validateStartDateInfo();
        }
      };

      return SchedulerLayout;

    })(Backbone.Marionette.LayoutView);
  });

}).call(this);
