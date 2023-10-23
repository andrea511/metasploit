(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/notification_center/layouts/notification_center_layout-385d8c0f06fda20218b3efe3438d3b06ce4b2a6d9f868e147ffd5765fada6673.js', '/assets/shared/notification-center/backbone/collections/notification_message_collection-88ff2970f07ccfa8455190c53fadc7b210c78009da8689d74053e45ad9bf5821.js', '/assets/shared/notification-center/backbone/views/item_views/notification_nav_bar_item_view-1c785e5d93c44c8e4ada4812c8048acf5b42206145143813ab0eb42dbaa2b2d8.js', '/assets/shared/notification-center/backbone/views/collection_views/notification_collection_view-df10de77d3d265192ccd9608defba4779d8242b331b4dec9e24b41a91c18311b.js', '/assets/shared/notification-center/backbone/views/item_views/notification_footer_item_view-634e4d0c6eac162da10ac0dbc201ba55cbb9939d607f5533b760e8548da6f545.js', '/assets/shared/notification-center/backbone/event_aggregators/event_aggregator-aaf737212decc864bf321c2e97db0fff23791a0271c939abc3da67cee19fcd44.js', '/assets/shared/notification-center/backbone/models/poll_presenter_model-68d80f03807d73b5b0fe56d71011439ccc91516b4ca3dd62251b0b4a692175da.js'], function($, NotificationCenterLayout, NotificationMessageCollection, NotificationNavBarItemView, NotificationCollectionView, NotificationFooterItemView, EventAggregator, PollPresenter) {
    return NotificationCenterLayout = (function(_super) {

      __extends(NotificationCenterLayout, _super);

      function NotificationCenterLayout() {
        this._message_destroyed = __bind(this._message_destroyed, this);

        this._reset_scroll_bar = __bind(this._reset_scroll_bar, this);

        this._toggle_notification_center = __bind(this._toggle_notification_center, this);

        this._update_unread_count_on_close = __bind(this._update_unread_count_on_close, this);

        this._trigger_close_dropdowns = __bind(this._trigger_close_dropdowns, this);

        this._message_type_changed = __bind(this._message_type_changed, this);

        this._unbind_from_global_close_event = __bind(this._unbind_from_global_close_event, this);

        this._bind_to_global_close_event = __bind(this._bind_to_global_close_event, this);

        this._bind_triggers = __bind(this._bind_triggers, this);

        this._load_more_notifications = __bind(this._load_more_notifications, this);

        this._update_nav_bar_counter_callback = __bind(this._update_nav_bar_counter_callback, this);

        this._update_nav_bar_counter = __bind(this._update_nav_bar_counter, this);

        this._update_unread_notifications = __bind(this._update_unread_notifications, this);

        this._load_more_notifications_callback = __bind(this._load_more_notifications_callback, this);

        this._poll_unread_notifications_callback = __bind(this._poll_unread_notifications_callback, this);

        this._poll_unread_notifications = __bind(this._poll_unread_notifications, this);

        this._mark_local_notification_as_unread = __bind(this._mark_local_notification_as_unread, this);

        this._mark_messages_as_read = __bind(this._mark_messages_as_read, this);

        this._sort_collections = __bind(this._sort_collections, this);

        this._init_composite_views = __bind(this._init_composite_views, this);

        this._init_collections_callback = __bind(this._init_collections_callback, this);
        return NotificationCenterLayout.__super__.constructor.apply(this, arguments);
      }

      NotificationCenterLayout.NOTIFICATION_NUMBER = 15;

      NotificationCenterLayout.MAX_NOTIFICATION_CENTER_HEIGHT_RATIO = .85;

      NotificationCenterLayout.prototype.template = HandlebarsTemplates['notification_center/layouts/notification_center_layout'];

      NotificationCenterLayout.prototype.triggers = {
        'mouseleave': 'notification-center:closable',
        'mouseenter': 'notification-center:unclosable'
      };

      NotificationCenterLayout.prototype.regions = {
        all_notifications: '.all-notifications .notifications-container .scrollable-container',
        notification_nav_bar: '.all-notifications .notifications-nav-bar',
        notifications_footer: '.all-notifications .notifications-footer'
      };

      NotificationCenterLayout.prototype.initialize = function() {
        this._init_collections();
        this._bind_triggers();
        return this.last_loaded_id = this.last_read_id;
      };

      NotificationCenterLayout.prototype.collection_count = 0;

      NotificationCenterLayout.prototype.last_read_id = $('meta[name="last-known-message"]').attr('content');

      NotificationCenterLayout.prototype._date_sorter = function(model) {
        var timestamp, weight;
        weight = 1;
        switch (model.get('kind')) {
          case 'system_notification':
            weight = 2;
            break;
          case 'update_notification':
            weight = 3;
        }
        return -(timestamp = Date.parse(model.get('created_at')) * 1000 * weight);
      };

      NotificationCenterLayout.prototype._init_collections = function() {
        var paramHash;
        this.notification_collection = new NotificationMessageCollection({
          comparator: this._date_sorter
        });
        this.notification_collection.comparator = this._date_sorter;
        this.system_notification_collection = new NotificationMessageCollection();
        this.minion_notification_collection = new NotificationMessageCollection();
        paramHash = {
          'limit': NotificationCenterLayout.NOTIFICATION_NUMBER
        };
        return this.notification_collection.fetch({
          data: paramHash,
          success: this._init_collections_callback
        });
      };

      NotificationCenterLayout.prototype._init_collections_callback = function(collection) {
        this._sort_collections(collection);
        this._init_composite_views(collection);
        this._mark_messages_as_read(collection, false, false);
        return this._update_have_messages_state(collection);
      };

      NotificationCenterLayout.prototype._init_composite_views = function() {
        this.all_notifications_collection_view = new NotificationCollectionView({
          collection: this.notification_collection
        });
        this.all_notifications.show(this.all_notifications_collection_view);
        this.notification_nav_bar_item_view = new NotificationNavBarItemView({});
        this.notification_nav_bar.show(this.notification_nav_bar_item_view);
        this.notification_footer_item_view = new NotificationFooterItemView({});
        this._update_more_footer_option(this.all_notifications_collection_view.collection);
        return this._poll_unread_notifications();
      };

      NotificationCenterLayout.prototype._update_more_footer_option = function(collection) {
        if (collection.length === NotificationCenterLayout.NOTIFICATION_NUMBER) {
          if (typeof this.notifications_footer.currentView === 'undefined') {
            this.notification_footer_item_view.delegateEvents();
            return this.notifications_footer.show(this.notification_footer_item_view);
          }
        } else {
          return this.notifications_footer.reset();
        }
      };

      NotificationCenterLayout.prototype._sort_collections = function(collection) {};

      NotificationCenterLayout.prototype._mark_messages_as_read = function(collection, update_local, isClosing) {
        var flattened_collection, unread_message_ids, unread_messages;
        if (this._is_notification_center_visible() || isClosing) {
          flattened_collection = collection.models.map(this._flatten_models);
          unread_messages = _.where(flattened_collection, {
            read: false
          });
          unread_message_ids = unread_messages.map(this._map_message_ids);
          this._send_read_messages(unread_message_ids);
          if (update_local) {
            _.each(unread_message_ids, this._mark_local_notification_as_unread);
          }
        }
        this.all_notifications_collection_view.redraw_with_sort_preserved();
        return this._update_more_footer_option(this.all_notifications_collection_view.collection);
      };

      NotificationCenterLayout.prototype._mark_local_notification_as_unread = function(model_id) {
        var model;
        model = this.notification_collection.get(model_id);
        return model.set('read', true);
      };

      NotificationCenterLayout.prototype._map_message_ids = function(item) {
        return item.id;
      };

      NotificationCenterLayout.prototype._flatten_models = function(model) {
        return {
          id: model.get('id'),
          read: model.get('read')
        };
      };

      NotificationCenterLayout.prototype._send_read_messages = function(unread_message_ids) {
        return $.ajax({
          type: 'POST',
          url: Routes.mark_read_notifications_messages_path(),
          data: {
            message_ids: unread_message_ids
          }
        });
      };

      NotificationCenterLayout.prototype._update_have_messages_state = function(collection) {
        var flattened_collection, unread_messages;
        flattened_collection = collection.models.map(this._flatten_models);
        unread_messages = _.where(flattened_collection, {
          read: false
        });
        if (unread_messages.length === 0) {
          return $('.drop-menu .notification-menu').addClass('empty');
        } else {
          return $('.drop-menu .notification-menu').removeClass('empty');
        }
      };

      NotificationCenterLayout.prototype._poll_unread_notifications = function() {
        var dropdown_option, last_read_id, paramHash;
        this.collection_count = this.notification_collection.length;
        this.last_read_id = this.notification_collection.at(0) != null ? this.notification_collection.at(0).id : 0;
        last_read_id = this.last_read_id;
        last_read_id = last_read_id === "" ? 0 : last_read_id;
        paramHash = {
          since: last_read_id
        };
        dropdown_option = $('[name="notification_type"]', this.el).val();
        if (dropdown_option !== '') {
          paramHash['kind'] = dropdown_option;
        }
        paramHash['unread'] = true;
        paramHash['limit'] = NotificationCenterLayout.NOTIFICATION_NUMBER;
        return this.notification_collection.fetch({
          data: paramHash,
          remove: false,
          success: this._poll_unread_notifications_callback
        });
      };

      NotificationCenterLayout.prototype._poll_unread_notifications_callback = function(collection) {
        if (!(typeof this.notifications_footer.currentView !== 'undefined')) {
          this._update_unread_notifications(collection, false);
        } else {
          this._update_unread_notifications(collection, true);
        }
        return setTimeout(this._poll_unread_notifications, 2400);
      };

      NotificationCenterLayout.prototype._load_more_notifications_callback = function(collection) {
        return this._update_unread_notifications(collection, false);
      };

      NotificationCenterLayout.prototype._update_unread_notifications = function(collection, trim) {
        var collection_from_view;
        if (this.collection_count !== collection.length) {
          collection_from_view = this.all_notifications_collection_view.collection;
          if (trim) {
            while (collection_from_view.length > NotificationCenterLayout.NOTIFICATION_NUMBER) {
              collection_from_view.pop();
            }
          }
          this.all_notifications_collection_view.redraw_with_sort_preserved();
          this._update_have_messages_state(collection);
          this._update_nav_bar_counter(collection);
          this._update_more_footer_option(collection);
          return this._reset_scroll_bar();
        }
      };

      NotificationCenterLayout.prototype._update_nav_bar_counter = function(collection) {
        var paramHash, poll_presenter;
        poll_presenter = new PollPresenter();
        paramHash = {
          'unread': true
        };
        return poll_presenter.fetch({
          data: paramHash,
          success: this._update_nav_bar_counter_callback
        });
      };

      NotificationCenterLayout.prototype._update_nav_bar_counter_callback = function(poll_presenter) {
        var $menu_item, count_element, count_from_model;
        count_element = $('.drop-menu .notification-menu .menu-title');
        count_from_model = poll_presenter.get('unread_message_count');
        if (count_element.html().replace(/\s/g, '') !== count_from_model.toString() && count_from_model !== 0) {
          if (!this._is_notification_center_visible()) {
            $menu_item = $('.drop-menu .notification-menu').addClass('flash');
            setTimeout((function() {
              return $menu_item.removeClass('flash');
            }), 200);
          }
        }
        return $('.drop-menu .notification-menu .menu-title').html(poll_presenter.get('unread_message_count'));
      };

      NotificationCenterLayout.prototype._load_more_notifications = function() {
        var before_notification_id, dropdown_option, num_notifications, paramHash;
        num_notifications = this.notification_collection.length;
        before_notification_id = this.notification_collection.at(0) != null ? this.notification_collection.at(num_notifications - 1).id : 0;
        paramHash = {
          before: before_notification_id
        };
        dropdown_option = $('[name="notification_type"]', this.el).val();
        if (dropdown_option !== '') {
          paramHash['kind'] = dropdown_option;
        }
        paramHash['limit'] = NotificationCenterLayout.NOTIFICATION_NUMBER;
        return this.notification_collection.fetch({
          data: paramHash,
          remove: false,
          success: this._load_more_notifications_callback
        });
      };

      NotificationCenterLayout.prototype._bind_triggers = function() {
        this.on('notification-center:closable', this._bind_to_global_close_event);
        this.on('notification-center:unclosable', this._unbind_from_global_close_event);
        EventAggregator.on('notification-message:destroy', this._message_destroyed);
        EventAggregator.on('notification-center:change:type', this._message_type_changed);
        EventAggregator.on('notification-center:load:more', this._load_more_notifications);
        $('.drop-menu .notification-menu .menu-title').on('click', this._toggle_notification_center);
        return $(document).on('click.notification-global-click', this._trigger_close_dropdowns);
      };

      NotificationCenterLayout.prototype._bind_to_global_close_event = function() {
        return EventAggregator.on('close:dropdowns', this._hide_notification_center, this);
      };

      NotificationCenterLayout.prototype._unbind_from_global_close_event = function() {
        return EventAggregator.off('close:dropdowns', this._hide_notification_center, this);
      };

      NotificationCenterLayout.prototype._message_type_changed = function() {
        var dropdown_option, last_read_id, paramHash;
        this.collection_count = -1;
        this._mark_messages_as_read(this.notification_collection, true, false);
        last_read_id = 0;
        paramHash = {
          since: last_read_id
        };
        dropdown_option = $('[name="notification_type"]', this.el).val();
        if (dropdown_option !== '') {
          paramHash['kind'] = dropdown_option;
        }
        paramHash['limit'] = NotificationCenterLayout.NOTIFICATION_NUMBER;
        return this.notification_collection.fetch({
          data: paramHash,
          success: this._poll_unread_notifications_callback,
          reset: true
        });
      };

      NotificationCenterLayout.prototype._trigger_close_dropdowns = function() {
        if (!this._is_notification_center_visible()) {
          return;
        }
        return EventAggregator.trigger('close:dropdowns');
      };

      NotificationCenterLayout.prototype._update_unread_count_on_close = function() {
        this._mark_messages_as_read(this.notification_collection, true, true);
        return this._message_destroyed();
      };

      NotificationCenterLayout.prototype._is_notification_center_visible = function() {
        return $('.notification-center-container').is(':visible');
      };

      NotificationCenterLayout.prototype._toggle_notification_center = function(e) {
        var elem;
        e.preventDefault();
        elem = $('.notification-center-container');
        elem.toggleClass('hidden');
        $('.notification-menu').toggleClass('selected');
        if (elem.hasClass('hidden')) {
          return this._update_unread_count_on_close();
        } else {
          return this._reset_scroll_bar();
        }
      };

      NotificationCenterLayout.prototype._hide_notification_center = function() {
        var elem, elem_box;
        elem = $('.notification-center-container');
        elem_box = $('.notification-menu').toggleClass('selected');
        if (!elem.hasClass('hidden')) {
          this._update_unread_count_on_close();
          elem.addClass('hidden');
        }
        if (elem_box.hasClass('selected')) {
          elem_box.removeClass('selected');
        }
        return this._unbind_from_global_close_event();
      };

      NotificationCenterLayout.prototype._reset_scroll_bar = function() {
        var containerHeight;
        containerHeight = $('.scrollable-container > div', this.el).height();
        return this.all_notifications_collection_view.reset_scroll_bar(NotificationCenterLayout.NOTIFICATION_NUMBER, this.el, NotificationCenterLayout.MAX_NOTIFICATION_CENTER_HEIGHT_RATIO);
      };

      NotificationCenterLayout.prototype._message_destroyed = function() {
        this._update_have_messages_state(this.notification_collection);
        this._update_nav_bar_counter(this.notification_collection);
        this._update_more_footer_option(this.notification_collection);
        return this._reset_scroll_bar();
      };

      NotificationCenterLayout.prototype._slide_notification_center = function() {
        return $(this.el).parent('div').toggleClass('collapse-notification-center');
      };

      return NotificationCenterLayout;

    })(Backbone.Marionette.LayoutView);
  });

}).call(this);
