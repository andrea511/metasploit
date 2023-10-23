(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define([], function() {
    var RequestCollectionView;
    return RequestCollectionView = (function(_super) {

      __extends(RequestCollectionView, _super);

      function RequestCollectionView() {
        return RequestCollectionView.__super__.constructor.apply(this, arguments);
      }

      return RequestCollectionView;

    })(Backbone.Marionette.CollectionView);
  });

}).call(this);
