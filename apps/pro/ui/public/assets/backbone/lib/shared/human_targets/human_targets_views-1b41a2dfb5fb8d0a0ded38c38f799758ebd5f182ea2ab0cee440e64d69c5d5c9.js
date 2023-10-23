(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_layout', 'base_view', 'base_itemview', 'lib/shared/human_targets/templates/layout'], function() {
    return this.Pro.module('Shared.HumanTargets', function(HumanTargets, App, Backbone, Marionette, $, _) {
      return HumanTargets.Layout = (function(_super) {

        __extends(Layout, _super);

        function Layout() {
          return Layout.__super__.constructor.apply(this, arguments);
        }

        Layout.prototype.template = Layout.prototype.templatePath('human_targets/layout');

        Layout.prototype.regions = {
          targetsRegion: '#human-targets-region'
        };

        return Layout;

      })(App.Views.Layout);
    });
  });

}).call(this);
