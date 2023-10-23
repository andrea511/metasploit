(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/notification_center/item_views/notification_footer/notification_footer_item_view-c04489e279366445cfd054aea654bc0f5c53cb97135817a87a2b5a58cd6aa6e6.js', '/assets/shared/notification-center/backbone/event_aggregators/event_aggregator-aaf737212decc864bf321c2e97db0fff23791a0271c939abc3da67cee19fcd44.js'], function($, template, EventAggregator) {
    var NotificationFooterItemView;
    return NotificationFooterItemView = (function(_super) {

      __extends(NotificationFooterItemView, _super);

      function NotificationFooterItemView() {
        this._bind_triggers = __bind(this._bind_triggers, this);

        this.onRender = __bind(this.onRender, this);
        return NotificationFooterItemView.__super__.constructor.apply(this, arguments);
      }

      NotificationFooterItemView.prototype.template = HandlebarsTemplates['notification_center/item_views/notification_footer/notification_footer_item_view'];

      NotificationFooterItemView.prototype.triggers = {
        'click .more-text': 'notification-footer:click:more'
      };

      NotificationFooterItemView.prototype.onRender = function() {
        return this._bind_triggers();
      };

      NotificationFooterItemView.prototype._bind_triggers = function() {
        return this.on('notification-footer:click:more', this._trigger_load_more, this);
      };

      NotificationFooterItemView.prototype._trigger_load_more = function() {
        return EventAggregator.trigger('notification-center:load:more');
      };

      return NotificationFooterItemView;

    })(Backbone.Marionette.ItemView);
  });

}).call(this);
