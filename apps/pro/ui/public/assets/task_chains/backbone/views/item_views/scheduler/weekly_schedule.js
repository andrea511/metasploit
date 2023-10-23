(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/task_chains/item_views/scheduler/weekly_schedule-c051c9ec99f64880605557a960714f60d400c2bd113c37fab1c5d5630afcfa90.js', '/assets/task_chains/backbone/views/item_views/scheduler/schedule-a894773d6816626a4fbee51c8e233270a30f54da9332d2cc433981c567f3b120.js'], function($, Template, Schedule) {
    var WeeklySchedule;
    return WeeklySchedule = (function(_super) {

      __extends(WeeklySchedule, _super);

      function WeeklySchedule() {
        return WeeklySchedule.__super__.constructor.apply(this, arguments);
      }

      WeeklySchedule.prototype.template = HandlebarsTemplates['task_chains/item_views/scheduler/weekly_schedule'];

      WeeklySchedule.prototype.onShow = function() {
        WeeklySchedule.__super__.onShow.apply(this, arguments);
        $('#weekday-time', this.el).timepicker({
          timeOnly: true,
          timeFormat: 'hh:mm tt z'
        });
        return $('#weekday-date', this.el).datepicker();
      };

      WeeklySchedule.prototype._formSubmit = function(e) {
        $('#weekday-date', this.el).datepicker('destroy');
        $('#weekday-time', this.el).timepicker('destroy');
        return WeeklySchedule.__super__._formSubmit.apply(this, arguments);
      };

      return WeeklySchedule;

    })(Schedule);
  });

}).call(this);
