(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/hosts/item_views/host_stats_overview_item_view-c0b59d0dfd7c6057fd9ebc78735a00ab0973827f684ffd4595362e0f5a32e1f0.js', '/assets/shared/notification-center/backbone/event_aggregators/event_aggregator-aaf737212decc864bf321c2e97db0fff23791a0271c939abc3da67cee19fcd44.js', '/assets/shared/backbone/layouts/modal-57927538cf64c26b47a2f8f54fdef926ef3c906fba72986d69e71e13cfe4422f.js', '/assets/hosts/backbone/views/item_views/form-6363341bbd5878d63fc1bab8da13e3ce9ee7a83d28ea0200be8775db3f483d5b.js'], function($, Template, EventAggregator, Modal, HostForm) {
    var HostStatsOverviewItemView;
    return HostStatsOverviewItemView = (function(_super) {

      __extends(HostStatsOverviewItemView, _super);

      function HostStatsOverviewItemView() {
        this.editClicked = __bind(this.editClicked, this);

        this.onRender = __bind(this.onRender, this);

        this._updateStatus = __bind(this._updateStatus, this);

        this.onDestroy = __bind(this.onDestroy, this);

        this.onShow = __bind(this.onShow, this);
        return HostStatsOverviewItemView.__super__.constructor.apply(this, arguments);
      }

      HostStatsOverviewItemView.prototype.template = HandlebarsTemplates['hosts/item_views/host_stats_overview_item_view'];

      HostStatsOverviewItemView.prototype.onShow = function() {
        return EventAggregator.on("tabs_layout:change:host", this._updateStatus);
      };

      HostStatsOverviewItemView.prototype.onDestroy = function() {
        return EventAggregator.off("tabs_layout:change:host");
      };

      HostStatsOverviewItemView.prototype.modelEvents = {
        'change': 'render'
      };

      HostStatsOverviewItemView.prototype._updateStatus = function(model) {
        this.model = model;
        return this.render();
      };

      HostStatsOverviewItemView.prototype.events = {
        'click a.edit-info': 'editClicked'
      };

      HostStatsOverviewItemView.prototype.onRender = function() {
        return $(this.el).tooltip();
      };

      HostStatsOverviewItemView.prototype.editClicked = function(e) {
        e.preventDefault();
        if (this.modal) {
          this.modal.destroy();
        }
        this.modal = new Modal({
          "class": 'flat',
          width: 400,
          buttons: [
            {
              name: 'Done',
              "class": 'close btn primary'
            }
          ]
        });
        this.modal.open();
        this.modal.content.show(new HostForm({
          model: this.model
        }));
        return this.modal._center();
      };

      return HostStatsOverviewItemView;

    })(Backbone.Marionette.LayoutView);
  });

}).call(this);
