(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/notification_center/item_views/notification_nav_bar/notification_nav_bar-924e9ba7b3088a6f3e2a906cdc92e3dfc67a022c1b60306b3ee810d3cc418fc1.js', '/assets/shared/notification-center/backbone/event_aggregators/event_aggregator-aaf737212decc864bf321c2e97db0fff23791a0271c939abc3da67cee19fcd44.js'], function($, template, EventAggregator) {
    var NotificationNavBarItemView;
    return NotificationNavBarItemView = (function(_super) {

      __extends(NotificationNavBarItemView, _super);

      function NotificationNavBarItemView() {
        return NotificationNavBarItemView.__super__.constructor.apply(this, arguments);
      }

      NotificationNavBarItemView.prototype.template = HandlebarsTemplates['notification_center/item_views/notification_nav_bar/notification_nav_bar'];

      NotificationNavBarItemView.prototype.triggers = {
        'change .sort-options select': 'sort:changed'
      };

      NotificationNavBarItemView.prototype.initialize = function() {
        return this._bind_triggers();
      };

      NotificationNavBarItemView.prototype._bind_triggers = function() {
        return this.on('sort:changed', this._update_notification_type);
      };

      NotificationNavBarItemView.prototype._update_notification_type = function() {
        return EventAggregator.trigger('notification-center:change:type');
      };

      return NotificationNavBarItemView;

    })(Backbone.Marionette.ItemView);
  });

}).call(this);
