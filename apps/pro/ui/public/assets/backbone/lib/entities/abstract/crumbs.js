(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_model', 'base_collection', 'lib/concerns/entities/chooser'], function() {
    return this.Pro.module("Entities", function(Entities, App, Backbone, Marionette, jQuery, _) {
      var API;
      Entities.Crumb = (function(_super) {

        __extends(Crumb, _super);

        function Crumb() {
          return Crumb.__super__.constructor.apply(this, arguments);
        }

        Crumb.prototype.defaults = {};

        return Crumb;

      })(Entities.Model);
      Entities.CrumbCollection = (function(_super) {

        __extends(CrumbCollection, _super);

        function CrumbCollection() {
          return CrumbCollection.__super__.constructor.apply(this, arguments);
        }

        CrumbCollection.prototype.model = Entities.Crumb;

        CrumbCollection.include("SingleChooser");

        return CrumbCollection;

      })(Entities.Collection);
      API = {
        getCrumbs: function(crumbs) {
          var crumbCollection;
          if (crumbs == null) {
            crumbs = [];
          }
          crumbCollection = new Entities.CrumbCollection(crumbs);
          crumbCollection.reset(crumbs);
          return crumbCollection;
        }
      };
      return App.reqres.setHandler("crumbs:entities", function(crumbs) {
        if (crumbs == null) {
          crumbs = [];
        }
        return API.getCrumbs(crumbs);
      });
    });
  });

}).call(this);
