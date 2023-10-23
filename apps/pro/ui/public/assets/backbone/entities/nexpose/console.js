(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_model', 'base_collection'], function() {
    return this.Pro.module("Entities.Nexpose", function(Nexpose, App) {
      var API;
      Nexpose.Console = (function(_super) {

        __extends(Console, _super);

        function Console() {
          this.destroy = __bind(this.destroy, this);
          return Console.__super__.constructor.apply(this, arguments);
        }

        Console.prototype.url = '/nexpose_consoles.json';

        Console.prototype.destroy = function(opts) {
          if (opts == null) {
            opts = {};
          }
          _.extend(opts, {
            url: '/nexpose_consoles/destroy.json',
            data: 'id=' + this.id
          });
          return Console.__super__.destroy.call(this, opts);
        };

        return Console;

      })(App.Entities.Model);
      API = {
        newConsole: function(attributes) {
          if (attributes == null) {
            attributes = {};
          }
          return new Nexpose.Console(attributes);
        }
      };
      return App.reqres.setHandler("new:nexpose:console:entity", function(attributes) {
        return API.newConsole(attributes);
      });
    });
  });

}).call(this);
