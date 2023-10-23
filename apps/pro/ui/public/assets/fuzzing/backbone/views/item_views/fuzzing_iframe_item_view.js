(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/fuzzing/item_views/fuzzing_iframe_item_view-7d7034fb9c8e6890ba6015b47249bbcae304ef2bc8c0ec926612578b9f50bb96.js', '/assets/fuzzing/backbone/event_aggregator-877f074e3bd99562df3055fdf25a64402c5b7197a8ea79162a8b09bd933a319a.js', '/assets/fuzzing/backbone/collections/request_group_collection-7df3379aa2c130ad18acc8e313e4591c091ea57698e8a2092d61e46700bebb39.js'], function($, Template, EventAggregator, RequestGroupCollection) {
    var FuzzingIframeItemView;
    return FuzzingIframeItemView = (function(_super) {

      __extends(FuzzingIframeItemView, _super);

      function FuzzingIframeItemView() {
        this._update_iframe_url = __bind(this._update_iframe_url, this);
        return FuzzingIframeItemView.__super__.constructor.apply(this, arguments);
      }

      FuzzingIframeItemView.prototype.template = HandlebarsTemplates['fuzzing/item_views/fuzzing_iframe_item_view'];

      FuzzingIframeItemView.prototype.initialize = function() {
        this.request_group_collection = RequestGroupCollection;
        return EventAggregator.on('iframe:update:url', this._update_iframe_url);
      };

      FuzzingIframeItemView.prototype._update_iframe_url = function() {
        var request_id;
        request_id = this.request_group_collection.at(this.request_group_collection.length - 1).get("id");
        return $('iframe', this.el).attr("src", "http://localhost:3791/" + request_id);
      };

      return FuzzingIframeItemView;

    })(Backbone.Marionette.ItemView);
  });

}).call(this);
