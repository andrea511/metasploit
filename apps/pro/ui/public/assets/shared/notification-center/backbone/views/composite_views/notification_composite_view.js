(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/notification_center/composite_views/notification_composite_view-19b08a87a0335ff3a4c478b638dcd32e684caa4607036956321b16fb1b502fc3.js', '/assets/shared/notification-center/backbone/views/item_views/notification_item_view-7534770c9a2882c251a58617b705294710f9924fa92d4b02c7de5ad9a63d55ae.js', '/assets/shared/notification-center/backbone/event_aggregators/event_aggregator-aaf737212decc864bf321c2e97db0fff23791a0271c939abc3da67cee19fcd44.js'], function($, template, NotificationItemView, EventAggregator) {
    var NotificationCompositeView;
    return NotificationCompositeView = (function(_super) {

      __extends(NotificationCompositeView, _super);

      function NotificationCompositeView() {
        return NotificationCompositeView.__super__.constructor.apply(this, arguments);
      }

      NotificationCompositeView.prototype.itemView = NotificationItemView;

      NotificationCompositeView.prototype.emptyView = NotificationItemView;

      NotificationCompositeView.prototype.template = HandlebarsTemplates['notification_center/composite_views/notification_composite_view'];

      NotificationCompositeView.prototype.triggers = {
        'change .sort-options select': 'sort:changed'
      };

      NotificationCompositeView.prototype.initialize = function() {
        return this._bind_triggers();
      };

      NotificationCompositeView.prototype._bind_triggers = function() {
        return this.on('sort:changed', this._update_notification_type);
      };

      NotificationCompositeView.prototype._update_notification_type = function() {
        return EventAggregator.trigger('notification-center:change:type');
      };

      NotificationCompositeView.prototype.redraw_with_sort_preserved = function() {
        return this.collection.trigger('reset');
      };

      return NotificationCompositeView;

    })(Backbone.Marionette.CompositeView);
  });

}).call(this);
