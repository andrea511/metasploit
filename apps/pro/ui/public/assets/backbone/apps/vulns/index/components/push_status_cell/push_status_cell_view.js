(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'base_itemview'], function($) {
    return this.Pro.module("Components.PushStatusCell", function(PushStatusCell, App, Backbone, Marionette, $, _) {
      return PushStatusCell.View = (function(_super) {

        __extends(View, _super);

        function View() {
          return View.__super__.constructor.apply(this, arguments);
        }

        View.prototype.template = function(data) {
          var hover_text, icon;
          if (!data.origin_type) {
            return "<div></div>";
          }
          icon = data['vuln.latest_nexpose_result.icon'];
          hover_text = data['vuln.latest_nexpose_result.hover_text'];
          return "<img class='nx-push-icon' src=\"" + icon + "\" title='" + hover_text + "' ></img>";
        };

        View.prototype.onRender = function() {
          return this.$el.tooltip();
        };

        return View;

      })(App.Views.Layout);
    });
  });

}).call(this);
