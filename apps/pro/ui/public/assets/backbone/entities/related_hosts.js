(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['base_model', 'base_collection', 'lib/concerns/entities/fetch_ids', 'lib/concerns/entities/vuln_attempt_statuses'], function() {
    return this.Pro.module("Entities", function(Entities, App) {
      var API;
      Entities.RelatedHosts = (function(_super) {

        __extends(RelatedHosts, _super);

        function RelatedHosts() {
          return RelatedHosts.__super__.constructor.apply(this, arguments);
        }

        RelatedHosts.include('VulnAttemptStatuses');

        RelatedHosts.prototype.defaults = {};

        RelatedHosts.prototype.fetchTags = function(successCallback) {
          return this.fetch({
            success: successCallback,
            url: Routes.host_tags_path(this.id)
          });
        };

        return RelatedHosts;

      })(App.Entities.Model);
      Entities.RelatedHostsCollection = (function(_super) {

        __extends(RelatedHostsCollection, _super);

        function RelatedHostsCollection() {
          this.url = __bind(this.url, this);
          return RelatedHostsCollection.__super__.constructor.apply(this, arguments);
        }

        RelatedHostsCollection.prototype.model = Entities.RelatedHosts;

        RelatedHostsCollection.prototype.initialize = function(models, opts) {
          if (opts == null) {
            opts = {};
          }
          this.workspace_id = opts.workspace_id || WORKSPACE_ID;
          return this.vuln_id = opts.vuln_id || VULN_ID;
        };

        RelatedHostsCollection.prototype.url = function() {
          return Routes.related_hosts_workspace_vuln_path(this.workspace_id, this.vuln_id);
        };

        return RelatedHostsCollection;

      })(App.Entities.Collection);
      API = {
        getRelatedHosts: function(workspace_id, vuln_id) {
          return new Entities.RelatedHostsCollection([], {
            workspace_id: workspace_id,
            vuln_id: vuln_id
          });
        }
      };
      return App.reqres.setHandler("relatedHosts:entities", function(opts) {
        var vid, wid;
        if (opts == null) {
          opts = {};
        }
        wid = opts.workspace_id ? opts.workspace_id : WORKSPACE_ID;
        vid = opts.vuln_id ? opts.vuln_id : VULN_ID;
        return API.getRelatedHosts(wid);
      });
    });
  });

}).call(this);
