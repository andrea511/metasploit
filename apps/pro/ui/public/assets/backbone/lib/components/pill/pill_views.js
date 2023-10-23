(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'base_itemview', 'lib/components/pill/templates/view'], function($) {
    return this.Pro.module("Components.Pill", function(Pill, App, Backbone, Marionette, $, _) {
      return Pill.View = (function(_super) {

        __extends(View, _super);

        function View() {
          return View.__super__.constructor.apply(this, arguments);
        }

        View.prototype.template = View.prototype.templatePath("pill/view");

        return View;

      })(App.Views.Layout);
    });
  });

}).call(this);
