(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_layout', 'base_view', 'base_itemview', 'base_compositeview', 'apps/brute_force_reuse/header/templates/layout'], function() {
    return this.Pro.module('BruteForceReuseApp.Header', function(Header, App) {
      return Header.Layout = (function(_super) {

        __extends(Layout, _super);

        function Layout() {
          return Layout.__super__.constructor.apply(this, arguments);
        }

        Layout.prototype.template = Layout.prototype.templatePath('brute_force_reuse/header/layout');

        Layout.prototype.className = 'brute-force-header';

        Layout.prototype.regions = {
          crumbs: '.crumbs-region'
        };

        return Layout;

      })(App.Views.Layout);
    });
  });

}).call(this);
