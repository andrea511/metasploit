(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_layout', 'base_view', 'base_itemview'], function() {
    return this.Pro.module('WebVulnsApp.Index', function(Index, App, Backbone, Marionette, $, _) {
      return Index.AddressCellView = (function(_super) {

        __extends(AddressCellView, _super);

        function AddressCellView() {
          return AddressCellView.__super__.constructor.apply(this, arguments);
        }

        AddressCellView.prototype.template = function(data) {
          return "<a href='" + (Routes.host_path(data.host_id)) + "'>" + data['host.address'] + "</a>";
        };

        return AddressCellView;

      })(App.Views.ItemView);
    });
  });

}).call(this);
