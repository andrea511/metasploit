(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_model', 'base_collection'], function() {
    return this.Pro.module("Entities", function(Entities, App) {
      var API;
      Entities.BruteForceReuseOptions = (function(_super) {

        __extends(BruteForceReuseOptions, _super);

        function BruteForceReuseOptions() {
          return BruteForceReuseOptions.__super__.constructor.apply(this, arguments);
        }

        BruteForceReuseOptions.prototype.defaults = {
          service_seconds: 60 * 15,
          overall_hours: 4,
          overall_minutes: 0,
          overall_seconds: 0,
          limit: false,
          run_type: 'reuse'
        };

        BruteForceReuseOptions.prototype.mutators = {
          overall_timeout: function() {
            return Math.floor(this.get('overall_hours')) * 60 * 60 + Math.floor(this.get('overall_minutes')) * 60 + Math.floor(this.get('overall_seconds'));
          },
          service_timeout: function() {
            return Math.floor(this.get('service_seconds'));
          },
          stop_on_success: function() {
            return !!this.get('limit');
          }
        };

        return BruteForceReuseOptions;

      })(App.Entities.Model);
      API = {
        newBruteForceReuseOptions: function(attributes) {
          if (attributes == null) {
            attributes = {};
          }
          return new Entities.BruteForceReuseOptions(attributes);
        }
      };
      return App.reqres.setHandler('new:brute_force_reuse_options:entity', function(attributes) {
        if (attributes == null) {
          attributes = {};
        }
        return API.newBruteForceReuseOptions(attributes);
      });
    });
  });

}).call(this);
