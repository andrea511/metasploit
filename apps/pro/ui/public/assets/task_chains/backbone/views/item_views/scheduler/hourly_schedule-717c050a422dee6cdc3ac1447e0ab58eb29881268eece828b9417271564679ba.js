(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/task_chains/item_views/scheduler/hourly_schedule-e644e5d450f9e8561b99ec93464371104066248ad21c0fa58b7b8b811891e7f7.js', '/assets/task_chains/backbone/views/item_views/scheduler/schedule-a894773d6816626a4fbee51c8e233270a30f54da9332d2cc433981c567f3b120.js'], function($, Template, Schedule) {
    var HourlySchedule;
    return HourlySchedule = (function(_super) {

      __extends(HourlySchedule, _super);

      function HourlySchedule() {
        return HourlySchedule.__super__.constructor.apply(this, arguments);
      }

      HourlySchedule.prototype.template = HandlebarsTemplates['task_chains/item_views/scheduler/hourly_schedule'];

      HourlySchedule.prototype.onShow = function() {
        HourlySchedule.__super__.onShow.apply(this, arguments);
        $('#weekday-time', this.el).timepicker({
          timeOnly: true,
          timeFormat: 'hh:mm tt z'
        });
        return $('#weekday-date', this.el).datepicker();
      };

      HourlySchedule.prototype._formSubmit = function(e) {
        $('#weekday-date', this.el).datepicker('destroy');
        $('#weekday-time', this.el).timepicker('destroy');
        return HourlySchedule.__super__._formSubmit.apply(this, arguments);
      };

      return HourlySchedule;

    })(Schedule);
  });

}).call(this);
