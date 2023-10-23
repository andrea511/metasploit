(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_layout', 'base_view', 'base_itemview', 'base_compositeview', 'apps/brute_force_reuse/index/templates/layout'], function() {
    return this.Pro.module('BruteForceReuseApp.Index', function(Index, App) {
      return Index.Layout = (function(_super) {

        __extends(Layout, _super);

        function Layout() {
          return Layout.__super__.constructor.apply(this, arguments);
        }

        Layout.prototype.template = Layout.prototype.templatePath('brute_force_reuse/index/layout');

        Layout.prototype.regions = {
          content: '.content-region'
        };

        Layout.prototype.triggers = {
          'click .target-selection-view a.launch:not(.disabled)': 'tab:credentials',
          'click .cred-selection-view a.launch:not(.disabled)': 'tab:review',
          'click .review-view .launch-container a:not(.disabled)': 'tab:launch'
        };

        Layout.prototype.events = {
          'click .review-view a.launch.disabled': 'reviewBadClick',
          'click .cred-selection-view a.launch.disabled': 'credBadClick',
          'click .target-selection-view a.launch.disabled': 'targetBadClick'
        };

        Layout.prototype.credBadClick = function() {
          return App.execute('flash:display', {
            title: 'Error',
            style: 'error',
            message: "You must add at least 1 credential to the list.",
            duration: 3000
          });
        };

        Layout.prototype.reviewBadClick = function() {};

        Layout.prototype.targetBadClick = function() {
          return App.execute('flash:display', {
            title: 'Error',
            style: 'error',
            message: "You must add at least 1 target to the list.",
            duration: 3000
          });
        };

        return Layout;

      })(App.Views.Layout);
    });
  });

}).call(this);
