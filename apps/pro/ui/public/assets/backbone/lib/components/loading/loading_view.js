(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_itemview'], function() {
    return this.Pro.module("Components.Loading", function(Loading, App, Backbone, Marionette, $, _) {
      return Loading.LoadingView = (function(_super) {

        __extends(LoadingView, _super);

        function LoadingView() {
          return LoadingView.__super__.constructor.apply(this, arguments);
        }

        LoadingView.prototype.template = false;

        LoadingView.prototype.className = "loading-container";

        LoadingView.prototype.onShow = function() {
          return $(this.el).addClass('tab-loading');
        };

        return LoadingView;

      })(App.Views.ItemView);
    });
  });

}).call(this);
