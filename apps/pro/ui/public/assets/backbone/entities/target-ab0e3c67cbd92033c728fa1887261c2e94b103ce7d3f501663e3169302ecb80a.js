(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['base_model', 'base_collection', 'lib/concerns/entities/fetch_ids'], function() {
    return this.Pro.module("Entities", function(Entities, App) {
      var API;
      Entities.Target = (function(_super) {

        __extends(Target, _super);

        function Target() {
          return Target.__super__.constructor.apply(this, arguments);
        }

        Target.prototype.url = function() {
          if (this.id != null) {
            return "/workspaces/" + WORKSPACE_ID + "/metasploit/credential/logins/" + this.id + ".json";
          } else {
            return "/workspaces/" + WORKSPACE_ID + "/metasploit/credential/logins.json";
          }
        };

        return Target;

      })(App.Entities.Model);
      Entities.TargetCollection = (function(_super) {

        __extends(TargetCollection, _super);

        function TargetCollection() {
          this.url = __bind(this.url, this);
          return TargetCollection.__super__.constructor.apply(this, arguments);
        }

        TargetCollection.include('FetchIDs');

        TargetCollection.prototype.model = Entities.Target;

        TargetCollection.prototype.initialize = function(models, opts) {
          var wid;
          if (opts == null) {
            opts = {};
          }
          wid = opts.workspace_id ? opts.workspace_id : WORKSPACE_ID;
          return this.workspace_id = opts.workspace_id || WORKSPACE_ID;
        };

        TargetCollection.prototype.url = function() {
          return this.url = "/workspaces/" + this.workspace_id + "/brute_force/reuse/targets.json";
        };

        return TargetCollection;

      })(App.Entities.Collection);
      API = {
        getTargets: function(models, opts) {
          var targets;
          targets = new Entities.TargetCollection(models, opts);
          return targets;
        },
        getTarget: function(id) {
          var target;
          target = new Entities.Target({
            id: id
          });
          target.fetch();
          return target;
        },
        newTarget: function(attributes) {
          if (attributes == null) {
            attributes = {};
          }
          return new Entities.Target(attributes);
        }
      };
      App.reqres.setHandler("targets:entities", function(models, opts) {
        var wid;
        if (opts == null) {
          opts = {};
        }
        wid = opts.workspace_id ? opts.workspace_id : WORKSPACE_ID;
        opts.workspace_id = wid;
        return API.getTargets(models, opts);
      });
      App.reqres.setHandler("target:entity", function(id) {
        return API.getTarget(id);
      });
      return App.reqres.setHandler("new:target:entity", function(attributes) {
        if (attributes == null) {
          attributes = {};
        }
        return API.newTarget(attributes);
      });
    });
  });

}).call(this);
