(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_model', 'base_collection'], function() {
    return this.Pro.module("Entities.BruteForceGuess", function(BruteForceGuess, App) {
      var API;
      BruteForceGuess.MutationOptions = (function(_super) {

        __extends(MutationOptions, _super);

        function MutationOptions() {
          return MutationOptions.__super__.constructor.apply(this, arguments);
        }

        return MutationOptions;

      })(App.Entities.Model);
      API = {
        getMutationOptionsSettings: function(opts) {
          return new BruteForceGuess.MutationOptions(opts);
        }
      };
      return App.reqres.setHandler("mutationOptions:entities", function(opts) {
        if (opts == null) {
          opts = {};
        }
        return API.getMutationOptionsSettings(opts);
      });
    });
  });

}).call(this);
