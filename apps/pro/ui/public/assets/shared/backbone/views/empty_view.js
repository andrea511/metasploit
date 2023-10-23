(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/shared/item_views/empty_view-77aa9acc53c69232f8956fc6bc7d725f803407ed7c428ea0773aaa1ef019ced5.js'], function($, Template) {
    var EmptyView;
    return EmptyView = (function(_super) {

      __extends(EmptyView, _super);

      function EmptyView() {
        return EmptyView.__super__.constructor.apply(this, arguments);
      }

      EmptyView.prototype.template = HandlebarsTemplates['shared/item_views/empty_view'];

      return EmptyView;

    })(Backbone.Marionette.ItemView);
  });

}).call(this);
