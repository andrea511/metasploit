(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'base_controller'], function() {
    return this.Pro.module("Components.Flash", function(Flash, App, Backbone, Marionette, $, _) {
      Flash.FlashController = (function(_super) {

        __extends(FlashController, _super);

        function FlashController() {
          return FlashController.__super__.constructor.apply(this, arguments);
        }

        FlashController.prototype.initialize = function(opts) {
          if (opts == null) {
            opts = {};
          }
          _.defaults(opts, {
            location: 'br',
            style: 'notice'
          });
          return $.growl(opts);
        };

        return FlashController;

      })(App.Controllers.Application);
      return App.commands.setHandler("flash:display", function(opts) {
        if (opts == null) {
          opts = {};
        }
        return new Flash.FlashController(opts);
      });
    });
  });

}).call(this);
