(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'base_layout', 'base_view', 'base_itemview', 'apps/brute_force_reuse/review/templates/layout'], function($) {
    return this.Pro.module('BruteForceReuseApp.Review', function(Review, App) {
      return Review.Layout = (function(_super) {

        __extends(Layout, _super);

        function Layout() {
          return Layout.__super__.constructor.apply(this, arguments);
        }

        Layout.prototype.className = 'review-view';

        Layout.prototype.ui = {
          form: 'form',
          launchBtn: '.launch-container a'
        };

        Layout.prototype.triggers = {
          'change @ui.form': 'form:changed',
          'input form': 'form:changed',
          'click a.back-creds': 'credentials:back',
          'click a.back-targets': 'targets:back'
        };

        Layout.prototype.regions = {
          targetRegion: '.target-region',
          credRegion: '.creds-region'
        };

        Layout.prototype.template = Layout.prototype.templatePath('brute_force_reuse/review/layout');

        Layout.prototype.disableLaunch = function() {
          return this.ui.launchBtn.addClass('disabled');
        };

        return Layout;

      })(App.Views.Layout);
    });
  });

}).call(this);
