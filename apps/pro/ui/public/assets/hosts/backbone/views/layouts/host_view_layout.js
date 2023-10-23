(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/hosts/layouts/host_view_layout-7e4d59d24578f3774540ee76dbe627294432f61d65cc34690e882ba0ee6c48ed.js'], function($, Template) {
    var HostViewLayout;
    return HostViewLayout = (function(_super) {

      __extends(HostViewLayout, _super);

      function HostViewLayout() {
        return HostViewLayout.__super__.constructor.apply(this, arguments);
      }

      HostViewLayout.prototype.template = HandlebarsTemplates['hosts/layouts/host_view_layout'];

      HostViewLayout.prototype.regions = {
        host_stats_overview: '.host-stats-overview',
        tags: '.tags'
      };

      return HostViewLayout;

    })(Backbone.Marionette.LayoutView);
  });

}).call(this);
