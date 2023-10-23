(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/task_chains/item_views/scheduler/daily_schedule-30abc5b23f5384204b679219d4ec59b5104035bf9cc882c7a5b424fcc58a51ac.js', '/assets/task_chains/backbone/views/item_views/scheduler/schedule-a894773d6816626a4fbee51c8e233270a30f54da9332d2cc433981c567f3b120.js'], function($, Template, Schedule) {
    var DailySchedule;
    return DailySchedule = (function(_super) {

      __extends(DailySchedule, _super);

      function DailySchedule() {
        return DailySchedule.__super__.constructor.apply(this, arguments);
      }

      DailySchedule.prototype.template = HandlebarsTemplates['task_chains/item_views/scheduler/daily_schedule'];

      DailySchedule.prototype.onShow = function() {
        DailySchedule.__super__.onShow.apply(this, arguments);
        $('#weekday-time', this.el).timepicker({
          timeOnly: true,
          timeFormat: 'hh:mm tt z'
        });
        return $('#weekday-date', this.el).datepicker();
      };

      DailySchedule.prototype._formSubmit = function(e) {
        $('#weekday-date', this.el).datepicker('destroy');
        $('#weekday-time', this.el).timepicker('destroy');
        return DailySchedule.__super__._formSubmit.apply(this, arguments);
      };

      return DailySchedule;

    })(Schedule);
  });

}).call(this);
