(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/task_chains/item_views/scheduler/monthly_schedule-d9a164016c08f8684b8c3f3dd65f2ef738f92238f0bf6056b2d995c62b3b17d5.js', '/assets/task_chains/backbone/views/item_views/scheduler/schedule-a894773d6816626a4fbee51c8e233270a30f54da9332d2cc433981c567f3b120.js'], function($, Template, Schedule) {
    var MonthlySchedule;
    return MonthlySchedule = (function(_super) {

      __extends(MonthlySchedule, _super);

      function MonthlySchedule() {
        return MonthlySchedule.__super__.constructor.apply(this, arguments);
      }

      MonthlySchedule.prototype.template = HandlebarsTemplates['task_chains/item_views/scheduler/monthly_schedule'];

      MonthlySchedule.prototype.events = _.extend({}, Schedule.prototype.events, {
        'change [name="schedule_recurrence[monthly][type]"]': '_changeType'
      });

      MonthlySchedule.prototype.onShow = function() {
        MonthlySchedule.__super__.onShow.apply(this, arguments);
        $('#weekday-time', this.el).timepicker({
          timeOnly: true,
          timeFormat: 'hh:mm tt z'
        });
        $('#weekday-date', this.el).datepicker();
        if ($('[name="schedule_recurrence[monthly][type]"').val() === 'day') {
          return $('[name="schedule_recurrence[monthly][day_interval]"').hide();
        } else {
          return $('[name="schedule_recurrence[monthly][day_index]"').hide();
        }
      };

      MonthlySchedule.prototype._formSubmit = function(e) {
        $('#weekday-date', this.el).datepicker('destroy');
        $('#weekday-time', this.el).timepicker('destroy');
        return MonthlySchedule.__super__._formSubmit.apply(this, arguments);
      };

      MonthlySchedule.prototype._changeType = function(e) {
        var type;
        e.stopPropagation();
        type = $(e.target).val();
        switch (type) {
          case 'day':
            $('[name="schedule_recurrence[monthly][day_interval]"').hide();
            return $('[name="schedule_recurrence[monthly][day_index]"').show();
          default:
            $('[name="schedule_recurrence[monthly][day_interval]"').show();
            return $('[name="schedule_recurrence[monthly][day_index]"').hide();
        }
      };

      return MonthlySchedule;

    })(Schedule);
  });

}).call(this);
