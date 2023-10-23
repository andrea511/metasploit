(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/shared/notification-center/backbone/event_aggregators/event_aggregator-aaf737212decc864bf321c2e97db0fff23791a0271c939abc3da67cee19fcd44.js', '/assets/hosts/backbone/models/host-75df51a08668a9a9cfe703a1f982afa60ba619dc2f4352fac14c9f9f4a4424dc.js'], function($, EventAggregator, Host) {
    var SingleHostPresenter;
    return SingleHostPresenter = (function(_super) {

      __extends(SingleHostPresenter, _super);

      function SingleHostPresenter() {
        this.url = __bind(this.url, this);

        this._updateTabs = __bind(this._updateTabs, this);

        this._updateHostInfo = __bind(this._updateHostInfo, this);
        return SingleHostPresenter.__super__.constructor.apply(this, arguments);
      }

      SingleHostPresenter.prototype.defaults = {
        tab_counts: {},
        host: {}
      };

      SingleHostPresenter.prototype.initialize = function(_arg) {
        this.id = _arg.id;
        this.on("change:host", this._updateHostInfo, this);
        return this.on("change:tab_counts", this._updateTabs, this);
      };

      SingleHostPresenter.prototype._updateHostInfo = function(model) {
        return EventAggregator.trigger("tabs_layout:change:host", new Host(model.get("host")));
      };

      SingleHostPresenter.prototype._updateTabs = function(model) {
        return EventAggregator.trigger("tabs_layout:change:count", new Backbone.Model(model.get('tab_counts')));
      };

      SingleHostPresenter.prototype.url = function(extension) {
        if (extension == null) {
          extension = '.json';
        }
        return "/hosts/" + this.id + "/poll_presenter" + extension;
      };

      return SingleHostPresenter;

    })(Backbone.Model);
  });

}).call(this);
