(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'lib/components/breadcrumbs/breadcrumbs_views', 'lib/entities/abstract/crumbs'], function() {
    return this.Pro.module("Components.Breadcrumbs", function(Breadcrumbs, App) {
      Breadcrumbs.BreadcrumbsController = (function(_super) {

        __extends(BreadcrumbsController, _super);

        function BreadcrumbsController() {
          return BreadcrumbsController.__super__.constructor.apply(this, arguments);
        }

        BreadcrumbsController.prototype.defaults = function() {
          return {
            crumbs: [
              {
                title: 'Crumb 1'
              }, {
                title: 'Crumb 2'
              }, {
                title: 'Crumb 3'
              }, {
                title: 'Crumb 4'
              }
            ]
          };
        };

        BreadcrumbsController.prototype.initialize = function(options) {
          var config;
          if (options == null) {
            options = {};
          }
          config = _.defaults(options, this._getDefaults());
          this.crumbsCollection = this.getCrumbs(config.crumbs);
          this.collectionView = this.getCollectionView(this.crumbsCollection);
          return this.setMainView(this.collectionView);
        };

        BreadcrumbsController.prototype.getCollectionView = function(crumbs) {
          return new Breadcrumbs.CrumbCollection({
            collection: crumbs
          });
        };

        BreadcrumbsController.prototype.getCrumbs = function(crumbs) {
          return App.request("crumbs:entities", crumbs);
        };

        return BreadcrumbsController;

      })(App.Controllers.Application);
      return App.reqres.setHandler("crumbs:component", function(options) {
        if (options == null) {
          options = {};
        }
        return new Breadcrumbs.BreadcrumbsController(options);
      });
    });
  });

}).call(this);
