(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_model', 'base_collection', 'lib/concerns/entities/input_generator'], function() {
    return this.Pro.module("Entities", function(Entities, App, Backbone, Marionette, jQuery, _) {
      var API;
      Entities.BruteForceGuessForm = (function(_super) {

        __extends(BruteForceGuessForm, _super);

        function BruteForceGuessForm() {
          return BruteForceGuessForm.__super__.constructor.apply(this, arguments);
        }

        BruteForceGuessForm.include("InputGenerator");

        BruteForceGuessForm.prototype.url = function() {
          return Routes.workspace_brute_force_guess_runs_path(WORKSPACE_ID);
        };

        BruteForceGuessForm.prototype.mutators = {
          overall_timeout: function() {
            var hash, hour, minutes, seconds, _ref, _ref1;
            hash = ((_ref = this.get('quick_bruteforce')) != null ? _ref.options : void 0) || ((_ref1 = this.get('bruteforce')) != null ? _ref1.quick_bruteforce.options : void 0);
            hour = Math.floor(hash.overall_timeout.hour);
            minutes = Math.floor(hash.overall_timeout.minutes);
            seconds = Math.floor(hash.overall_timeout.seconds);
            return hour * 60 * 60 + minutes * 60 + seconds;
          }
        };

        return BruteForceGuessForm;

      })(Entities.Model);
      API = {
        newBruteForceGuessForm: function(attributes) {
          if (attributes == null) {
            attributes = {};
          }
          return new Entities.BruteForceGuessForm(attributes);
        }
      };
      return App.reqres.setHandler("new:brute_force_guess_form:entity", function(attributes) {
        if (attributes == null) {
          attributes = {};
        }
        return API.newBruteForceGuessForm(attributes);
      });
    });
  });

}).call(this);
