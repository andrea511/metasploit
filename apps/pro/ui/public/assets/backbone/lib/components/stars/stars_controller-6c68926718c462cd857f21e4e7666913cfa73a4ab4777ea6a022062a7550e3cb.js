(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'lib/components/stars/stars_views', 'css!css/components/stars'], function() {
    return this.Pro.module("Components.Stars", function(Stars, App) {
      Stars.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.RATING = 5;

        Controller.prototype.defaults = function() {
          return {
            rating: this.RATING
          };
        };

        Controller.prototype.initialize = function(options) {
          var config, model, view;
          if (options == null) {
            options = {};
          }
          config = _.defaults(options, this._getDefaults());
          model = new Backbone.Model(config);
          view = new Stars.View();
          view.model = model;
          return this.setMainView(view);
        };

        return Controller;

      })(App.Controllers.Application);
      return App.reqres.setHandler('stars:component', function(options) {
        if (options == null) {
          options = {};
        }
        return new Stars.Controller(options);
      });
    });
  });

}).call(this);
