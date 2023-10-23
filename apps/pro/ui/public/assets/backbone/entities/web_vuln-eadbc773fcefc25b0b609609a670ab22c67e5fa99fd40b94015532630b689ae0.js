(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_model', 'base_collection'], function() {
    return this.Pro.module("Entities", function(Entities, App) {
      var API;
      Entities.WebVuln = (function(_super) {

        __extends(WebVuln, _super);

        function WebVuln() {
          return WebVuln.__super__.constructor.apply(this, arguments);
        }

        WebVuln.prototype.url = function() {
          var _ref;
          return Routes.workspace_web_vuln_path((_ref = this.get('workspace_id')) != null ? _ref : WORKSPACE_ID, this.id, {
            format: 'json'
          });
        };

        return WebVuln;

      })(App.Entities.Model);
      Entities.WebVulnsCollection = (function(_super) {

        __extends(WebVulnsCollection, _super);

        function WebVulnsCollection() {
          return WebVulnsCollection.__super__.constructor.apply(this, arguments);
        }

        WebVulnsCollection.prototype.model = Entities.WebVuln;

        WebVulnsCollection.prototype.initialize = function(models, opts) {
          if (opts == null) {
            opts = {};
          }
          return _.defaults(this, {
            workspace_id: WORKSPACE_ID
          });
        };

        WebVulnsCollection.prototype.url = function() {
          return "" + (Routes.workspace_web_vulns_path({
            workspace_id: this.workspace_id
          })) + ".json";
        };

        return WebVulnsCollection;

      })(App.Entities.Collection);
      API = {
        getWebVulns: function(workspace_id) {
          var vulns;
          vulns = new Entities.WebVulnsCollection([], {
            workspace_id: workspace_id
          });
          return vulns;
        },
        getWebVuln: function(id) {
          return new Entities.WebVuln({
            id: id
          });
        },
        newWebVuln: function(attributes) {
          if (attributes == null) {
            attributes = {};
          }
          return new Entities.WebVuln(attributes);
        }
      };
      App.reqres.setHandler("web_vulns:entities", function(opts) {
        var vulns;
        if (opts == null) {
          opts = {};
        }
        _.defaults(opts, {
          fetch: true
        });
        vulns = API.getWebVulns(opts);
        if (opts.fetch) {
          vulns.fetch();
        }
        return vulns;
      });
      return App.reqres.setHandler("web_vuln:entity", function(id) {
        return API.getWebVuln(id);
      });
    });
  });

}).call(this);
