(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_model', 'base_collection'], function() {
    return this.Pro.module("Entities", function(Entities, App) {
      var API;
      Entities.Host = (function(_super) {

        __extends(Host, _super);

        function Host() {
          return Host.__super__.constructor.apply(this, arguments);
        }

        Host.prototype.url = function() {
          return "/hosts/" + this.id + ".json";
        };

        return Host;

      })(App.Entities.Model);
      Entities.HostsCollection = (function(_super) {

        __extends(HostsCollection, _super);

        function HostsCollection() {
          return HostsCollection.__super__.constructor.apply(this, arguments);
        }

        HostsCollection.prototype.initialize = function(models, opts) {
          this.workspace_id = opts.workspace_id;
          return this.url = function() {
            var baseUrl;
            baseUrl = "/workspaces/" + this.workspace_id + "/hosts";
            if (opts.limited) {
              return "" + baseUrl + "/json_limited";
            } else {
              return "" + baseUrl + "/json";
            }
          };
        };

        HostsCollection.prototype.model = Entities.Host;

        return HostsCollection;

      })(App.Entities.Collection);
      API = {
        getHosts: function(model, opts) {
          var hosts;
          hosts = new Entities.HostsCollection(model, opts);
          return hosts;
        },
        getHostsLimited: function(model, opts) {
          opts.limited = true;
          return API.getHosts(model, opts);
        }
      };
      App.reqres.setHandler("hosts:entities", function(model, opts) {
        if (opts == null) {
          opts = {};
        }
        if (opts.workspace_id == null) {
          throw new Error("missing workspace_id");
        }
        return API.getHosts(model, opts);
      });
      return App.reqres.setHandler("hosts:entities:limited", function(model, opts) {
        if (opts == null) {
          opts = {};
        }
        if (opts.workspace_id == null) {
          throw new Error("missing workspace_id");
        }
        return API.getHostsLimited(model, opts);
      });
    });
  });

}).call(this);
