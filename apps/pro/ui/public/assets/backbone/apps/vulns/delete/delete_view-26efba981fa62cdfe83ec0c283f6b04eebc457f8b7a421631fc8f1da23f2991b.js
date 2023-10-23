(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_layout', 'apps/vulns/delete/templates/delete_layout'], function() {
    return this.Pro.module('VulnsApp.Delete', function(Delete, App) {
      return Delete.Layout = (function(_super) {

        __extends(Layout, _super);

        function Layout() {
          return Layout.__super__.constructor.apply(this, arguments);
        }

        Layout.prototype.template = Layout.prototype.templatePath('vulns/delete/delete_layout');

        return Layout;

      })(App.Views.Layout);
    });
  });

}).call(this);
