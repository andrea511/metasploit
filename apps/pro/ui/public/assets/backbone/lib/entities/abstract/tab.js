(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_model', 'base_collection', 'lib/concerns/entities/chooser'], function() {
    return this.Pro.module("Entities", function(Entities, App, Backbone, Marionette, jQuery, _) {
      var API;
      Entities.Tab = (function(_super) {

        __extends(Tab, _super);

        function Tab() {
          return Tab.__super__.constructor.apply(this, arguments);
        }

        Tab.prototype.defaults = {
          title: "Tab"
        };

        return Tab;

      })(Entities.Model);
      Entities.TabCollection = (function(_super) {

        __extends(TabCollection, _super);

        function TabCollection() {
          return TabCollection.__super__.constructor.apply(this, arguments);
        }

        TabCollection.prototype.model = Entities.Tab;

        TabCollection.include("SingleChooser");

        return TabCollection;

      })(Entities.Collection);
      API = {
        getTab: function(options) {
          if (options == null) {
            options = {};
          }
          return new Entities.Tab(options);
        },
        getTabs: function(models) {
          if (models == null) {
            models = [];
          }
          return new Entities.TabCollection(models);
        }
      };
      App.reqres.setHandler("component:tab:entity", function(options) {
        if (options == null) {
          options = {};
        }
        return API.getTab(options);
      });
      return App.reqres.setHandler("component:tab:entities", function(models) {
        if (models == null) {
          models = [];
        }
        return API.getTabs(models);
      });
    });
  });

}).call(this);
