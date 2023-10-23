(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_layout', 'base_view', 'base_itemview', 'apps/brute_force_guess/index/templates/index_layout'], function() {
    return this.Pro.module('BruteForceGuessApp.Index', function(Index, App, Backbone, Marionette, $, _) {
      return Index.Layout = (function(_super) {

        __extends(Layout, _super);

        function Layout() {
          return Layout.__super__.constructor.apply(this, arguments);
        }

        Layout.prototype.template = Layout.prototype.templatePath('brute_force_guess/index/index_layout');

        Layout.prototype.regions = {
          contentRegion: '#content-region'
        };

        return Layout;

      })(App.Views.Layout);
    });
  });

}).call(this);
