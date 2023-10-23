(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'lib/components/os/os_views', 'css!css/components/os'], function() {
    return this.Pro.module("Components.Os", function(Os, App) {
      Os.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.defaults = function() {
          return {
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
          view = new Os.View();
          _.extend(model.get('model'), {
            mutators: {
              parsedIcons: {
                get: function() {
                  return JSON.parse(this.get('module_icons'));
                }
              }
            }
          });
          view.model = model;
          return this.setMainView(view);
        };

        return Controller;

      })(App.Controllers.Application);
      return App.reqres.setHandler('os:component', function(options) {
        if (options == null) {
          options = {};
        }
        return new Os.Controller(options);
      });
    });
  });

}).call(this);
