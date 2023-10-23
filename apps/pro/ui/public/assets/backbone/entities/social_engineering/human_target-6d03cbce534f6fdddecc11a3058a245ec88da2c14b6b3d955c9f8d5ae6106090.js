(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['base_model', 'base_collection', 'lib/concerns/entities/fetch_ids'], function() {
    return this.Pro.module("Entities.SocialEngineering", function(SocialEngineering, App) {
      var API;
      SocialEngineering.HumanTarget = (function(_super) {

        __extends(HumanTarget, _super);

        function HumanTarget() {
          return HumanTarget.__super__.constructor.apply(this, arguments);
        }

        HumanTarget.prototype.url = function() {
          return Routes.workspace_social_engineering_target_list_human_targets_path(WORSKSPACE_ID, this.targetListIds) + '.json';
        };

        return HumanTarget;

      })(App.Entities.Model);
      SocialEngineering.HumanTargetCollection = (function(_super) {

        __extends(HumanTargetCollection, _super);

        function HumanTargetCollection() {
          this.url = __bind(this.url, this);
          return HumanTargetCollection.__super__.constructor.apply(this, arguments);
        }

        HumanTargetCollection.include('FetchIDs');

        HumanTargetCollection.prototype.model = SocialEngineering.HumanTarget;

        HumanTargetCollection.prototype.initialize = function(models, opts) {
          return this.targetListId = opts.targetListId;
        };

        HumanTargetCollection.prototype.url = function() {
          return Routes.workspace_social_engineering_target_list_human_targets_path(WORKSPACE_ID, this.targetListId) + '.json';
        };

        return HumanTargetCollection;

      })(App.Entities.Collection);
      API = {
        getHumanTargets: function(opts) {
          return new SocialEngineering.HumanTargetCollection([], opts);
        }
      };
      return App.reqres.setHandler("socialEngineering:humanTarget:entities", function(opts) {
        if (opts == null) {
          opts = {};
        }
        return API.getHumanTargets(opts);
      });
    });
  });

}).call(this);
