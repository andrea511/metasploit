(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_model', 'base_collection'], function() {
    return this.Pro.module("Entities", function(Entities, App) {
      var API;
      Entities.Loot = (function(_super) {

        __extends(Loot, _super);

        function Loot() {
          return Loot.__super__.constructor.apply(this, arguments);
        }

        return Loot;

      })(App.Entities.Model);
      Entities.LootCollection = (function(_super) {

        __extends(LootCollection, _super);

        function LootCollection() {
          return LootCollection.__super__.constructor.apply(this, arguments);
        }

        LootCollection.prototype.initialize = function(models, _arg) {
          this.host_id = _arg.host_id, this.index = _arg.index;
          if (this.index) {
            return this.url = Routes.workspace_loots_path(WORKSPACE_ID);
          } else {
            return this.url = "/hosts/" + this.host_id + "/show_loots/json";
          }
        };

        LootCollection.prototype.model = Entities.Loot;

        return LootCollection;

      })(App.Entities.Collection);
      API = {
        getLoots: function(opts) {
          if (opts == null) {
            opts = {};
          }
          return new Entities.LootCollection([], opts);
        },
        getLoot: function(id) {
          return new Entities.Loot({
            id: id
          });
        },
        newLoot: function(attributes) {
          if (attributes == null) {
            attributes = {};
          }
          return new Entities.Loot(attributes);
        }
      };
      App.reqres.setHandler("loots:entities", function(opts) {
        if (opts == null) {
          opts = {};
        }
        return API.getLoots(opts);
      });
      App.reqres.setHandler("loots:entity", function(id) {
        return API.getLoot(id);
      });
      return App.reqres.setHandler("new:loot:entity", function(attributes) {
        return API.newLoot(attributes);
      });
    });
  });

}).call(this);
