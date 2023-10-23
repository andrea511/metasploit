(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'base_layout', 'base_itemview', 'base_collectionview', 'base_compositeview'], function($) {
    return this.Pro.module("Components.Table", function(Table, App, Backbone, Marionette, $, _) {
      Table.Empty = (function(_super) {

        __extends(Empty, _super);

        function Empty() {
          return Empty.__super__.constructor.apply(this, arguments);
        }

        Empty.prototype.tagName = 'tr';

        Empty.prototype.attributes = {
          "class": 'empty'
        };

        return Empty;

      })(App.Views.ItemView);
      return Table.Loading = (function(_super) {

        __extends(Loading, _super);

        function Loading() {
          return Loading.__super__.constructor.apply(this, arguments);
        }

        Loading.prototype.tagName = 'tr';

        return Loading;

      })(App.Views.ItemView);
    });
  });

}).call(this);
