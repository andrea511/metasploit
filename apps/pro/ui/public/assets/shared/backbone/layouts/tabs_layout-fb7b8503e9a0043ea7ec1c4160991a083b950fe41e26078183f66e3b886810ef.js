(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/shared/layouts/tabs-e1d7d46f9385166b728f445e5fc0b46afd9a1c77495fbe60799cd4bf652e0032.js', '/assets/templates/shared/layouts/_tabs-dc5d617b8bf82d94c63bf25afb6b8bec6f5ddf66501d5ee9af3805659b162dbe.js', '/assets/shared/notification-center/backbone/event_aggregators/event_aggregator-aaf737212decc864bf321c2e97db0fff23791a0271c939abc3da67cee19fcd44.js'], function($, Template, Partial, EventAggregator) {
    var BOTTOM_MARGIN, TabsLayout;
    BOTTOM_MARGIN = 55;
    return TabsLayout = (function(_super) {

      __extends(TabsLayout, _super);

      function TabsLayout() {
        this._content_div = __bind(this._content_div, this);

        this._tab_loading = __bind(this._tab_loading, this);

        this._setFocus = __bind(this._setFocus, this);

        this._tab_loaded = __bind(this._tab_loaded, this);

        this._change_tab = __bind(this._change_tab, this);

        this._update_tab = __bind(this._update_tab, this);

        this._update_tab_counts = __bind(this._update_tab_counts, this);

        this._set_max_height = __bind(this._set_max_height, this);

        this.onRender = __bind(this.onRender, this);
        return TabsLayout.__super__.constructor.apply(this, arguments);
      }

      TabsLayout.prototype.template = HandlebarsTemplates['shared/layouts/tabs'];

      TabsLayout.prototype.events = {
        'click .nav li': '_change_tab_event',
        'tableload table': '_tab_loaded',
        'tabload .content>*': '_tab_loaded',
        'tabloading .content>*': '_tab_loading',
        'tabcountUpdated .content>*': '_tab_count_updated'
      };

      TabsLayout.prototype.regions = {
        nav: '.nav',
        content: '.content'
      };

      TabsLayout.prototype.initialize = function(opts) {
        this.opts = opts != null ? opts : {};
        $.extend(this, this.opts);
        return this._bind_events();
      };

      TabsLayout.prototype.onRender = function() {
        var _this = this;
        return _.defer(function() {
          return _this._set_max_height();
        });
      };

      TabsLayout.prototype._tab_count_updated = function(e, opts) {
        var tab_name;
        if (opts == null) {
          opts = {};
        }
        tab_name = _.string.underscored(opts.name);
        return this._update_tab(opts.count, tab_name);
      };

      TabsLayout.prototype._set_max_height = function() {
        var $content, max;
        $content = $(this.content.el, this.el);
        if (this.maxHeight != null) {
          return $content.css('max-height', this.maxHeight);
        } else {
          max = $(window).height() - $content.offset().top - BOTTOM_MARGIN;
          return $content.css('max-height', parseInt(max) + 'px');
        }
      };

      TabsLayout.prototype._bind_events = function() {
        EventAggregator.on("tabs_layout:change:count", this._update_tab_counts);
        return $(window).bind('resize.tabs_layout', this._set_max_height);
      };

      TabsLayout.prototype._update_tab_counts = function(model) {
        return _.each(model.attributes, this._update_tab);
      };

      TabsLayout.prototype._update_tab = function(value, key) {
        var $count, $li, isZero, tab_class;
        tab_class = key;
        $li = $(".backbone-tabs ul ." + tab_class, this.el).closest("li");
        $count = $li.find(".count");
        if ($count.length === 0) {
          $count = $('<div />', {
            "class": 'count'
          }).text(value).appendTo($li);
        }
        $count.text(value);
        isZero = parseInt(value) === 0;
        return $count.toggle(!isZero);
      };

      TabsLayout.prototype._change_tab_event = function(e) {
        var $tab, tab_name;
        $tab = $('.name', e.currentTarget);
        tab_name = $tab.html();
        this._change_tab(tab_name);
        this._mark_tab_as_selected($tab.closest('li'));
        return EventAggregator.trigger('tabs_layout:tab:changed', tab_name);
      };

      TabsLayout.prototype._change_tab = function(tab_name) {
        var tab_hash, tabs;
        tabs = this.model.get('tabs');
        if (!tab_name) {
          tab_name = tabs[0].name;
        }
        tab_name = _.string.humanize(tab_name);
        tab_hash = $.grep(tabs, function(elem) {
          return elem.name === _.string.titleize(tab_name);
        })[0];
        this._content_div().addClass('tab-loading');
        return this.content.show(new tab_hash.view(_.extend({
          controller: tab_hash.controller
        }, this.opts)));
      };

      TabsLayout.prototype._mark_tab_as_selected = function($tab) {
        $('.nav li.selected', this.el).removeClass('selected');
        return $tab.addClass('selected');
      };

      TabsLayout.prototype._get_tag_elem_by_name = function(tab_name) {
        tab_name = _.string.underscored(tab_name);
        return $(".nav li .name." + tab_name, this.el).closest('li');
      };

      TabsLayout.prototype._tab_loaded = function() {
        this._content_div().removeClass('tab-loading');
        this._set_max_height();
        if ($(this.el).closest('.window-slider-pane').length > 0) {
          if (!$('#modals>*').length) {
            return _.delay(this._setFocus, 3000);
          }
        } else {
          if (!$('#modals>*').length) {
            return this._setFocus;
          }
        }
      };

      TabsLayout.prototype._setFocus = function() {
        return $('.dataTables_filter input[type=text]', this.el).first().focus();
      };

      TabsLayout.prototype._tab_loading = function() {
        return this._content_div().addClass('tab-loading');
      };

      TabsLayout.prototype._content_div = function() {
        return $(this.content.el, this.el);
      };

      TabsLayout.prototype.set_tab = function(tab_name) {
        var $tab;
        this._change_tab(tab_name);
        $tab = this._get_tag_elem_by_name(tab_name);
        return this._mark_tab_as_selected($tab);
      };

      return TabsLayout;

    })(Backbone.Marionette.LayoutView);
  });

}).call(this);
