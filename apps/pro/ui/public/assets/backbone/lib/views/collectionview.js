(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_view'], function() {
    return this.Pro.module("Views", function(Views, App) {
      Views.CollectionView = (function(_super) {

        __extends(CollectionView, _super);

        function CollectionView() {
          return CollectionView.__super__.constructor.apply(this, arguments);
        }

        return CollectionView;

      })(Marionette.CollectionView);
      return Views.SortableCollectionView = (function(_super) {

        __extends(SortableCollectionView, _super);

        function SortableCollectionView() {
          return SortableCollectionView.__super__.constructor.apply(this, arguments);
        }

        return SortableCollectionView;

      })(Marionette.CollectionView);
    });
  });

}).call(this);
