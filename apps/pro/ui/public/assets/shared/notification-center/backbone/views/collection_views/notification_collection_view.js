(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/notification_center/composite_views/notification_composite_view-19b08a87a0335ff3a4c478b638dcd32e684caa4607036956321b16fb1b502fc3.js', '/assets/shared/notification-center/backbone/views/item_views/notification_item_view-7534770c9a2882c251a58617b705294710f9924fa92d4b02c7de5ad9a63d55ae.js', '/assets/shared/notification-center/backbone/event_aggregators/event_aggregator-aaf737212decc864bf321c2e97db0fff23791a0271c939abc3da67cee19fcd44.js'], function($, template, NotificationItemView, EventAggregator) {
    var NotificationCollectionView;
    return NotificationCollectionView = (function(_super) {

      __extends(NotificationCollectionView, _super);

      function NotificationCollectionView() {
        this.reset_scroll_bar = __bind(this.reset_scroll_bar, this);
        return NotificationCollectionView.__super__.constructor.apply(this, arguments);
      }

      NotificationCollectionView.prototype.childView = NotificationItemView;

      NotificationCollectionView.prototype.emptyView = NotificationItemView;

      NotificationCollectionView.prototype.template = HandlebarsTemplates['notification_center/composite_views/notification_composite_view'];

      NotificationCollectionView.prototype.redraw_with_sort_preserved = function() {
        return this.collection.trigger('reset');
      };

      NotificationCollectionView.prototype.onRender = function() {
        var debounced_function;
        debounced_function = _.debounce(this._load_more_notifications, 500);
        $(".nano").off("scrollend");
        return $(".nano").on("scrollend", debounced_function);
      };

      NotificationCollectionView.prototype.onBeforeDestroy = function() {
        return $(".nano").off("scrollend");
      };

      NotificationCollectionView.prototype.reset_scroll_bar = function(limit, el, heightRatio) {
        var containerHeight, height, ratioHeight;
        ratioHeight = $(window).height() * heightRatio;
        containerHeight = $(this.el).height();
        height = ratioHeight < containerHeight ? ratioHeight : containerHeight;
        if (this.collection.length > limit) {
          $('.nano', el).css('height', height);
          return $('.nano', el).nanoScroller({
            preventPageScrolling: true
          });
        } else {
          $('.nano', el).nanoScroller({
            stop: true
          });
          return $('.nano', el).css('height', containerHeight);
        }
      };

      NotificationCollectionView.prototype._load_more_notifications = function() {
        return EventAggregator.trigger('notification-center:load:more');
      };

      return NotificationCollectionView;

    })(Backbone.Marionette.CollectionView);
  });

}).call(this);
