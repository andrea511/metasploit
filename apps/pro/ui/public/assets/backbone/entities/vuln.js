(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_model', 'base_collection'], function() {
    return this.Pro.module("Entities", function(Entities, App) {
      var API;
      Entities.Vuln = (function(_super) {

        __extends(Vuln, _super);

        function Vuln() {
          return Vuln.__super__.constructor.apply(this, arguments);
        }

        Vuln.prototype.url = function() {
          var _ref;
          if (this.get('new_vuln_attempt_status') != null) {
            return Routes.update_last_vuln_attempt_status_workspace_vuln_path(this.get('workspace_id'), this.get('id'));
          } else if (this.get('restore_vuln_attempt_status') != null) {
            return Routes.restore_last_vuln_attempt_status_workspace_vuln_path(this.get('workspace_id'), this.get('id'));
          } else {
            return Routes.workspace_vuln_path((_ref = this.get('workspace_id')) != null ? _ref : WORKSPACE_ID, this.id, {
              format: 'json'
            });
          }
        };

        Vuln.prototype.updateLastVulnStatus = function(status) {
          return this.save({
            'new_vuln_attempt_status': status
          }, {
            success: function(model) {
              return model.unset('new_vuln_attempt_status');
            }
          });
        };

        Vuln.prototype.restoreLastVulnStatus = function() {
          return this.save({
            'restore_vuln_attempt_status': true
          }, {
            success: function(model) {
              return model.unset('restore_vuln_attempt_status');
            }
          });
        };

        return Vuln;

      })(App.Entities.Model);
      Entities.VulnsCollection = (function(_super) {

        __extends(VulnsCollection, _super);

        function VulnsCollection() {
          return VulnsCollection.__super__.constructor.apply(this, arguments);
        }

        VulnsCollection.prototype.model = Entities.Vuln;

        VulnsCollection.prototype.initialize = function(models, opts) {
          if (opts == null) {
            opts = {};
          }
          return _.defaults(this, {
            workspace_id: WORKSPACE_ID
          });
        };

        VulnsCollection.prototype.url = function() {
          return "" + (Routes.workspace_vulns_path({
            workspace_id: this.workspace_id
          })) + ".json";
        };

        return VulnsCollection;

      })(App.Entities.Collection);
      API = {
        getVulns: function(workspace_id) {
          var vulns;
          vulns = new Entities.VulnsCollection([], {
            workspace_id: workspace_id
          });
          return vulns;
        },
        getVuln: function(id) {
          return new Entities.Vuln({
            id: id
          });
        },
        newVuln: function(attributes) {
          if (attributes == null) {
            attributes = {};
          }
          return new Entities.Vuln(attributes);
        }
      };
      App.reqres.setHandler("vulns:entities", function(opts) {
        var vulns;
        if (opts == null) {
          opts = {};
        }
        _.defaults(opts, {
          fetch: true
        });
        vulns = API.getVulns(opts);
        if (opts.fetch) {
          vulns.fetch();
        }
        return vulns;
      });
      App.reqres.setHandler("vuln:entity", function(id) {
        return API.getVuln(id);
      });
      return App.reqres.setHandler("new:vuln:entity", function(attributes) {
        return API.newVuln(attributes);
      });
    });
  });

}).call(this);
