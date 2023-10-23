(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['base_model', 'base_collection', 'lib/concerns/entities/fetch_ids', 'lib/concerns/entities/vuln_attempt_statuses'], function() {
    return this.Pro.module("Entities", function(Entities, App) {
      var API;
      Entities.VulnHistory = (function(_super) {

        __extends(VulnHistory, _super);

        function VulnHistory() {
          return VulnHistory.__super__.constructor.apply(this, arguments);
        }

        VulnHistory.include('VulnAttemptStatuses');

        return VulnHistory;

      })(App.Entities.Model);
      Entities.VulnHistoryCollection = (function(_super) {

        __extends(VulnHistoryCollection, _super);

        function VulnHistoryCollection() {
          this.url = __bind(this.url, this);
          return VulnHistoryCollection.__super__.constructor.apply(this, arguments);
        }

        VulnHistoryCollection.prototype.model = Entities.VulnHistory;

        VulnHistoryCollection.prototype.initialize = function(models, opts) {
          if (opts == null) {
            opts = {};
          }
          this.workspace_id = opts.workspace_id || WORKSPACE_ID;
          return this.vuln_id = opts.vuln_id || VULN_ID;
        };

        VulnHistoryCollection.prototype.url = function() {
          return Routes.history_workspace_vuln_path(this.workspace_id, this.vuln_id);
        };

        return VulnHistoryCollection;

      })(App.Entities.Collection);
      API = {
        getVulnHistory: function(workspace_id, vuln_id) {
          return new Entities.VulnHistoryCollection([], {
            workspace_id: workspace_id,
            vuln_id: vuln_id
          });
        }
      };
      return App.reqres.setHandler("vulnHistory:entities", function(opts) {
        var vid, wid;
        if (opts == null) {
          opts = {};
        }
        wid = opts.workspace_id ? opts.workspace_id : WORKSPACE_ID;
        vid = opts.vuln_id ? opts.vuln_id : VULN_ID;
        return API.getVulnHistory(wid);
      });
    });
  });

}).call(this);
