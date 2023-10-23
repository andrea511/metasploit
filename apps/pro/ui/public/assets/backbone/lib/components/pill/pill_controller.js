(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'lib/components/pill/pill_views', 'css!css/components/pill'], function() {
    return this.Pro.module("Components.Pill", function(Pill, App) {
      Pill.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.COLORS = {
          RED: 'red',
          GREEN: 'green',
          BLACK: 'black',
          BLUE: 'blue'
        };

        Controller.prototype.defaults = function() {
          return {
            color: this.COLORS.RED,
            content: 'Default Content'
          };
        };

        Controller.prototype.initialize = function(options) {
          var config, model, view;
          if (options == null) {
            options = {};
          }
          config = _.defaults(options, this._getDefaults());
          model = new Backbone.Model(config);
          view = new Pill.View();
          view.model = model;
          return this.setMainView(view);
        };

        return Controller;

      })(App.Controllers.Application);
      return App.reqres.setHandler('pill:component', function(options) {
        if (options == null) {
          options = {};
        }
        return new Pill.Controller(options);
      });
    });
  });

}).call(this);
