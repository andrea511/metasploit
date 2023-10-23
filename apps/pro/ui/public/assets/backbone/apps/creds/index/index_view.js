(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_layout', 'base_view', 'base_itemview', 'apps/creds/index/templates/index_layout', 'lib/components/table/table_view'], function() {
    return this.Pro.module('CredsApp.Index', function(Index, App, Backbone, Marionette, $, _) {
      return Index.Layout = (function(_super) {

        __extends(Layout, _super);

        function Layout() {
          return Layout.__super__.constructor.apply(this, arguments);
        }

        Layout.prototype.template = Layout.prototype.templatePath('creds/index/index_layout');

        Layout.prototype.regions = {
          credsRegion: '#creds-region',
          filterRegion: '.filter-region'
        };

        Layout.prototype.updateCredsTotal = function(count) {
          return $('#total-count', this.$el).html(count);
        };

        Layout.prototype.setCarpenterChannel = function(channel) {
          this.channel = channel;
          return this.channel.on('total_records:change', this.updateCredsTotal);
        };

        Layout.prototype.onBeforeDestroy = function() {
          return this.channel.off('total_records:change');
        };

        return Layout;

      })(App.Views.Layout);
    });
  });

}).call(this);
