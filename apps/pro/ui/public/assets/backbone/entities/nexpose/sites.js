(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_model', 'base_collection', 'lib/concerns/entities/fetch_ids'], function() {
    return this.Pro.module("Entities.Nexpose", function(Nexpose, App) {
      var API;
      Nexpose.Site = (function(_super) {

        __extends(Site, _super);

        function Site() {
          return Site.__super__.constructor.apply(this, arguments);
        }

        Site.prototype.url = function() {
          return Routes.workspace_nexpose_data_sites_path(WORKSPACE_ID);
        };

        return Site;

      })(App.Entities.Model);
      Nexpose.SiteCollection = (function(_super) {

        __extends(SiteCollection, _super);

        function SiteCollection() {
          return SiteCollection.__super__.constructor.apply(this, arguments);
        }

        SiteCollection.include('FetchIDs');

        SiteCollection.prototype.initialize = function(models, opts) {
          return _.extend(this, opts);
        };

        SiteCollection.prototype.model = Nexpose.Site;

        SiteCollection.prototype.url = function() {
          var root;
          root = Routes.workspace_nexpose_data_sites_path(WORKSPACE_ID);
          if (this.nexpose_import_run_id != null) {
            root = root + ("?nexpose_import_run_id=" + this.nexpose_import_run_id);
          }
          return root;
        };

        return SiteCollection;

      })(App.Entities.Collection);
      API = {
        getSites: function(models, opts) {
          var sites;
          if (opts == null) {
            opts = {};
          }
          sites = new Nexpose.SiteCollection(models, opts);
          return sites;
        }
      };
      return App.reqres.setHandler("nexpose:sites:entities", function(models, opts) {
        if (opts == null) {
          opts = {};
        }
        return API.getSites(models, opts);
      });
    });
  });

}).call(this);
