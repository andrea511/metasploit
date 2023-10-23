(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'base_layout', 'lib/components/content_container/templates/layout'], function($) {
    return this.Pro.module("Components.ContentContainer", function(ContentContainer, App) {
      return ContentContainer.Layout = (function(_super) {

        __extends(Layout, _super);

        function Layout() {
          return Layout.__super__.constructor.apply(this, arguments);
        }

        Layout.prototype.template = Layout.prototype.templatePath("content_container/layout");

        Layout.prototype.regions = {
          header: '.header-region',
          content: '.content-region'
        };

        return Layout;

      })(App.Views.Layout);
    });
  });

}).call(this);
