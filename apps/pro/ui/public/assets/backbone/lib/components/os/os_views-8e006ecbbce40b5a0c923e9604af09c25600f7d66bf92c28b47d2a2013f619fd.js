(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'base_itemview', 'lib/components/os/templates/view'], function($) {
    return this.Pro.module("Components.Os", function(Os, App, Backbone, Marionette, $, _) {
      return Os.View = (function(_super) {

        __extends(View, _super);

        function View() {
          return View.__super__.constructor.apply(this, arguments);
        }

        View.prototype.template = View.prototype.templatePath("os/view");

        View.prototype.className = 'icon-logo';

        return View;

      })(App.Views.Layout);
    });
  });

}).call(this);
