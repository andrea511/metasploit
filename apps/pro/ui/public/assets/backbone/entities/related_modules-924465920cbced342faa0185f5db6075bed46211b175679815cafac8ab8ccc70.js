(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['base_model', 'base_collection', 'lib/concerns/entities/fetch_ids'], function() {
    return this.Pro.module("Entities", function(Entities, App) {
      var API;
      Entities.RelatedModules = (function(_super) {

        __extends(RelatedModules, _super);

        function RelatedModules() {
          return RelatedModules.__super__.constructor.apply(this, arguments);
        }

        return RelatedModules;

      })(App.Entities.Model);
      Entities.WorkspaceRelatedModules = (function(_super) {

        __extends(WorkspaceRelatedModules, _super);

        function WorkspaceRelatedModules() {
          return WorkspaceRelatedModules.__super__.constructor.apply(this, arguments);
        }

        return WorkspaceRelatedModules;

      })(App.Entities.Model);
      ({
        defaults: {}
      });
      Entities.RelatedModulesCollection = (function(_super) {

        __extends(RelatedModulesCollection, _super);

        function RelatedModulesCollection() {
          this.url = __bind(this.url, this);
          return RelatedModulesCollection.__super__.constructor.apply(this, arguments);
        }

        RelatedModulesCollection.prototype.model = Entities.RelatedModules;

        RelatedModulesCollection.prototype.initialize = function(models, opts) {
          if (opts == null) {
            opts = {};
          }
          this.workspace_id = opts.workspace_id || WORKSPACE_ID;
          return this.vuln_id = opts.vuln_id || VULN_ID;
        };

        RelatedModulesCollection.prototype.url = function() {
          return Routes.related_modules_workspace_vuln_path(this.workspace_id, this.vuln_id);
        };

        return RelatedModulesCollection;

      })(App.Entities.Collection);
      Entities.WorkspaceRelatedModulesCollection = (function(_super) {

        __extends(WorkspaceRelatedModulesCollection, _super);

        function WorkspaceRelatedModulesCollection() {
          this.url = __bind(this.url, this);
          return WorkspaceRelatedModulesCollection.__super__.constructor.apply(this, arguments);
        }

        WorkspaceRelatedModulesCollection.prototype.model = Entities.WorkspaceRelatedModules;

        WorkspaceRelatedModulesCollection.prototype.initialize = function(models, opts) {
          if (opts == null) {
            opts = {};
          }
          return this.workspace_id = opts.workspace_id || WORKSPACE_ID;
        };

        WorkspaceRelatedModulesCollection.prototype.url = function() {
          return Routes.workspace_related_modules_path(this.workspace_id);
        };

        return WorkspaceRelatedModulesCollection;

      })(App.Entities.Collection);
      API = {
        getRelatedModules: function(workspace_id, vuln_id) {
          return new Entities.RelatedModulesCollection([], {
            workspace_id: workspace_id,
            vuln_id: vuln_id
          });
        },
        getWorkspaceRelatedModules: function(workspace_id) {
          return new Entities.WorkspaceRelatedModulesCollection([], {
            workspace_id: workspace_id
          });
        }
      };
      App.reqres.setHandler("relatedModules:entities", function(opts) {
        var vid, wid;
        if (opts == null) {
          opts = {};
        }
        wid = opts.workspace_id ? opts.workspace_id : WORKSPACE_ID;
        vid = opts.vuln_id ? opts.vuln_id : VULN_ID;
        return API.getRelatedModules(wid);
      });
      return App.reqres.setHandler("workspaceRelatedModules:entities", function(opts) {
        var wid;
        if (opts == null) {
          opts = {};
        }
        wid = opts.workspace_id ? opts.workspace_id : WORKSPACE_ID;
        return API.getWorkspaceRelatedModules(wid);
      });
    });
  });

}).call(this);
