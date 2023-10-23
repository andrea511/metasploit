(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'base_itemview', 'lib/components/stars/templates/view'], function($) {
    return this.Pro.module("Components.Stars", function(Stars, App, Backbone, Marionette, $, _) {
      return Stars.View = (function(_super) {

        __extends(View, _super);

        function View() {
          return View.__super__.constructor.apply(this, arguments);
        }

        View.prototype.template = View.prototype.templatePath("stars/view");

        return View;

      })(App.Views.ItemView);
    });
  });

}).call(this);
