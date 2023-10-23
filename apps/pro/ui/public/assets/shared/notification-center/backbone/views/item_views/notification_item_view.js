(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/notification_center/item_views/notification_item_view-adb9f4b9bc99d94d87c15a0d1490d9093ce01eedd11094e4325d2fcff7eed8b4.js', '/assets/templates/notification_center/item_views/_notification-4af37b314e5a1709707e9ae1b6a49e5963e98a63e0f9da0743f785828a23be87.js', '/assets/shared/notification-center/backbone/event_aggregators/event_aggregator-aaf737212decc864bf321c2e97db0fff23791a0271c939abc3da67cee19fcd44.js'], function($, template, partial, EventAggregator) {
    var NotificationItemView;
    return NotificationItemView = (function(_super) {

      __extends(NotificationItemView, _super);

      function NotificationItemView() {
        this._destroy_callback = __bind(this._destroy_callback, this);
        return NotificationItemView.__super__.constructor.apply(this, arguments);
      }

      NotificationItemView.prototype.template = HandlebarsTemplates['notification_center/item_views/notification_item_view'];

      NotificationItemView.prototype.triggers = {
        'click': 'notification:link:goto',
        'click .action-bar': 'notification:close',
        'click .text': 'tooltip:toggle'
      };

      NotificationItemView.prototype.initialize = function() {
        return this._bind_triggers();
      };

      NotificationItemView.prototype._bind_triggers = function() {
        this.on('notification:close', this._close_notification, this);
        this.on('notification:link:goto', this._redirect_notification_link);
        return this.on('tooltip:toggle', this._toggle_tooltip_text);
      };

      NotificationItemView.prototype._toggle_tooltip_text = function() {
        return this.$el.children().first().toggleClass('tooltip');
      };

      NotificationItemView.prototype._redirect_notification_link = function() {
        if (this.model.get('url') != null) {
          if (this.model.get('url').startsWith(window.location.pathname)) {
            return window.location.reload();
          } else {
            return window.location.href = this.model.get('url');
          }
        }
      };

      NotificationItemView.prototype._close_notification = function() {
        return this.model.destroy({
          success: this._destroy_callback
        });
      };

      NotificationItemView.prototype._destroy_callback = function(model, response) {
        return EventAggregator.trigger('notification-message:destroy');
      };

      return NotificationItemView;

    })(Backbone.Marionette.ItemView);
  });

}).call(this);
