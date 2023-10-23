(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_model', 'base_collection'], function() {
    return this.Pro.module("Entities", function(Entities, App) {
      var API;
      Entities.BruteForceRun = (function(_super) {

        __extends(BruteForceRun, _super);

        function BruteForceRun() {
          return BruteForceRun.__super__.constructor.apply(this, arguments);
        }

        BruteForceRun.prototype.defaults = {
          workspace_id: null,
          host_ids: [],
          credential_ids: [],
          config: {}
        };

        BruteForceRun.prototype.url = function() {
          return "/workspaces/" + (this.get('workspace_id')) + "/brute_force/runs.json";
        };

        return BruteForceRun;

      })(App.Entities.Model);
      API = {
        newBruteForceRun: function(attributes) {
          if (attributes == null) {
            attributes = {};
          }
          return new Entities.BruteForceRun(attributes);
        }
      };
      return App.reqres.setHandler("new:brute_force_run:entity", function(attributes) {
        if (attributes == null) {
          attributes = {};
        }
        return API.newBruteForceRun(attributes);
      });
    });
  });

}).call(this);
