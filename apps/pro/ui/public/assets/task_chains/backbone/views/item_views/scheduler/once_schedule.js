(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/task_chains/item_views/scheduler/once_schedule-cebbff0f72bf5c28c40d62a827494bfb769c21e2e1a9a5d0fa1d735a859d5e9b.js', '/assets/task_chains/backbone/views/item_views/scheduler/schedule-a894773d6816626a4fbee51c8e233270a30f54da9332d2cc433981c567f3b120.js'], function($, Template, Schedule) {
    var OnceSchedule;
    return OnceSchedule = (function(_super) {

      __extends(OnceSchedule, _super);

      function OnceSchedule() {
        return OnceSchedule.__super__.constructor.apply(this, arguments);
      }

      OnceSchedule.prototype.template = HandlebarsTemplates['task_chains/item_views/scheduler/once_schedule'];

      OnceSchedule.prototype.onShow = function() {
        OnceSchedule.__super__.onShow.apply(this, arguments);
        $('#weekday-time', this.el).timepicker({
          timeOnly: true,
          timeFormat: 'hh:mm tt z'
        });
        return $('#weekday-date', this.el).datepicker();
      };

      OnceSchedule.prototype._formSubmit = function(e) {
        $('#weekday-date', this.el).datepicker('destroy');
        $('#weekday-time', this.el).timepicker('destroy');
        return OnceSchedule.__super__._formSubmit.apply(this, arguments);
      };

      return OnceSchedule;

    })(Schedule);
  });

}).call(this);
