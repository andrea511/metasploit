(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery'], function($) {
    var BannerMessageCollection;
    return BannerMessageCollection = (function(_super) {

      __extends(BannerMessageCollection, _super);

      function BannerMessageCollection() {
        return BannerMessageCollection.__super__.constructor.apply(this, arguments);
      }

      BannerMessageCollection.prototype.url = '/banner_messages.json';

      return BannerMessageCollection;

    })(Backbone.Collection);
  });

}).call(this);
