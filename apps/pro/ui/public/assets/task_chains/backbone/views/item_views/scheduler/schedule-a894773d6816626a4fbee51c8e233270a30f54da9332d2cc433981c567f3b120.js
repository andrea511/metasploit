(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery'], function($) {
    var Schedule;
    return Schedule = (function(_super) {

      __extends(Schedule, _super);

      function Schedule() {
        return Schedule.__super__.constructor.apply(this, arguments);
      }

      Schedule.prototype.ui = {
        schedule_type: '#schedule_type',
        toggle_button: '[name="schedule_suspend"]',
        form: 'form'
      };

      Schedule.prototype.events = {
        'submit form': '_formSubmit',
        'change #schedule_type': '_scheduleTypeChanged'
      };

      Schedule.prototype.initialize = function(opts) {
        if (opts == null) {
          opts = {};
        }
        return _.extend(this, opts);
      };

      Schedule.prototype.render = function() {
        if ((this.cachedEl != null) || (this.restoreEl != null)) {
          this.isClosed = false;
          this.triggerMethod("before:render", this);
          this.triggerMethod("item:before:render", this);
          if (this.restoreEl != null) {
            this.$el.html(this.restoreEl);
          } else {
            this.$el.html(this.cachedEl);
          }
          this.bindUIElements();
          this.triggerMethod("render", this);
          this.triggerMethod("item:rendered", this);
          return this;
        } else {
          return Schedule.__super__.render.apply(this, arguments);
        }
      };

      Schedule.prototype.onShow = function() {
        this.restoreEl = helpers.cloneNodeAndForm(this.el);
        this.undelegateEvents();
        this.delegateEvents();
        if (this.model == null) {
          return this.ui.toggle_button.trigger('toggleTitle');
        }
      };

      Schedule.prototype._formSubmit = function(e) {
        this.restoreEl = null;
        this.cachedEl = helpers.cloneNodeAndForm(this.el);
        return $(this.el).trigger('closeSchedule');
      };

      Schedule.prototype._scheduleTypeChanged = function() {
        return $(this.el).trigger('scheduleChanged', this.ui.schedule_type);
      };

      return Schedule;

    })(Backbone.Marionette.ItemView);
  });

}).call(this);
