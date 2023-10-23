(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_view', 'base_itemview'], function() {
    return this.Pro.module('HostsApp.Index', function(Index, App, Backbone, Marionette, $, _) {
      return Index.VirtualCellView = (function(_super) {

        __extends(VirtualCellView, _super);

        function VirtualCellView() {
          return VirtualCellView.__super__.constructor.apply(this, arguments);
        }

        VirtualCellView.prototype.template = function(data) {
          if (data.virtual_host) {
            return "<img title=\"" + data.virtual_host + "\" src=\"/assets/icons/os/vm_logo-93c1860595c834295429f25c8b0a3b3358790412ea9960646c9316306713d47a.png\" />";
          } else {
            return "&nbsp;";
          }
        };

        return VirtualCellView;

      })(Pro.Views.ItemView);
    });
  });

}).call(this);
