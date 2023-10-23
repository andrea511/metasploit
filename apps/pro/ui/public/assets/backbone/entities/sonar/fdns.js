(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['base_model', 'base_collection', 'lib/concerns/entities/fetch_ids'], function() {
    return this.Pro.module("Entities", function(Entities, App) {
      var API;
      Entities.Fdns = (function(_super) {

        __extends(Fdns, _super);

        function Fdns() {
          return Fdns.__super__.constructor.apply(this, arguments);
        }

        Fdns.prototype.url = function() {
          return Routes.workspace_sonar_fdnss_index_path(WORKSPACE_ID) + '.json';
        };

        return Fdns;

      })(App.Entities.Model);
      Entities.FdnsCollection = (function(_super) {

        __extends(FdnsCollection, _super);

        function FdnsCollection() {
          this.url = __bind(this.url, this);
          return FdnsCollection.__super__.constructor.apply(this, arguments);
        }

        FdnsCollection.include('FetchIDs');

        FdnsCollection.prototype.model = Entities.Fdns;

        FdnsCollection.prototype.initialize = function(models, opts) {
          return this.import_run_id = opts.import_run_id;
        };

        FdnsCollection.prototype.url = function() {
          return Routes.workspace_sonar_import_fdnss_index_path(WORKSPACE_ID, this.import_run_id) + '.json';
        };

        return FdnsCollection;

      })(App.Entities.Collection);
      API = {
        getFdnss: function(opts) {
          return new Entities.FdnsCollection([], opts);
        }
      };
      return App.reqres.setHandler("fdnss:entities", function(opts) {
        if (opts == null) {
          opts = {};
        }
        return API.getFdnss(opts);
      });
    });
  });

}).call(this);
