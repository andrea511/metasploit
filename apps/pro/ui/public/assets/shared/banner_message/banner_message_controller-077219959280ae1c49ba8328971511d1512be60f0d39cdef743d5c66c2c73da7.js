(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/shared/banner_message/banner_message_collection-883480361dc5e1137125f9948a2e63473206b159011e17da0c94ec808a76af74.js'], function($, BannerMessageCollection) {
    var BannerMessageController;
    return BannerMessageController = (function(_super) {

      __extends(BannerMessageController, _super);

      function BannerMessageController() {
        return BannerMessageController.__super__.constructor.apply(this, arguments);
      }

      BannerMessageController.prototype.initialize = function() {
        var collection, self;
        collection = new BannerMessageCollection();
        self = this;
        return collection.fetch({
          reset: true,
          success: function(data) {
            return self.displayBannerMessages(data);
          }
        });
      };

      BannerMessageController.prototype.displayBannerMessages = function(collection) {
        var _this = this;
        return collection.each(function(model, index) {
          $.growl({
            title: model.get('title'),
            location: 'br',
            style: 'warning',
            "static": true,
            size: 'large',
            message: "<div class='banner-message'>\n  <p>" + (model.get('message')) + "</p>\n</div>"
          });
          return _this.bind(model);
        });
      };

      BannerMessageController.prototype.bind = function(model) {
        var _this = this;
        return $('.banner-message').parent().siblings('.growl-close').on('click', function() {
          return jQuery.ajax({
            url: "/banner_messages/read",
            type: 'POST',
            data: {
              banner_id: model.get('id')
            }
          });
        });
      };

      return BannerMessageController;

    })(Backbone.Marionette.Controller);
  });

}).call(this);
