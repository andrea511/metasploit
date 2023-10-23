(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/fuzzing/item_views/request_input_item_view-c2abcbf83471e14b18cecc6b063a704bf6d31165878049869e3e933b5ccbf9f7.js', '/assets/fuzzing/backbone/collections/request_group_collection-7df3379aa2c130ad18acc8e313e4591c091ea57698e8a2092d61e46700bebb39.js', '/assets/fuzzing/backbone/models/request_group_model-b785de01c976c17cc198a6264e9ee31cfa922cdb7b7ddb6e7814b780ec2f722c.js', '/assets/fuzzing/backbone/event_aggregator-877f074e3bd99562df3055fdf25a64402c5b7197a8ea79162a8b09bd933a319a.js'], function($, Template, RequestGroupCollection, RequestGroupModel, EventAggregator) {
    var RequestInputView;
    return RequestInputView = (function(_super) {

      __extends(RequestInputView, _super);

      function RequestInputView() {
        this._save_collection = __bind(this._save_collection, this);

        this.iframeRequest = __bind(this.iframeRequest, this);
        return RequestInputView.__super__.constructor.apply(this, arguments);
      }

      RequestInputView.prototype.template = HandlebarsTemplates['fuzzing/item_views/request_input_item_view'];

      RequestInputView.prototype.triggers = {
        'click .row button': 'iframe:request'
      };

      RequestInputView.prototype.initialize = function() {
        this.on('iframe:request', this.iframeRequest);
        return this.request_group_collection = RequestGroupCollection;
      };

      RequestInputView.prototype.iframeRequest = function() {
        var attrs, proxy_url,
          _this = this;
        proxy_url = $('textarea', this.el).val();
        this.request_group = new RequestGroupModel({
          proxy_url: proxy_url
        });
        attrs = {
          workspace_id: 1,
          fuzzing_id: 3
        };
        return this.request_group.save(attrs, {
          success: function(model, response, options) {
            return _this._save_collection();
          },
          error: function(model, response, options) {
            return console.log(e);
          }
        });
      };

      RequestInputView.prototype._save_collection = function() {
        this.request_group_collection.add(this.request_group);
        return EventAggregator.trigger('iframe:update:url');
      };

      return RequestInputView;

    })(Backbone.Marionette.ItemView);
  });

}).call(this);
