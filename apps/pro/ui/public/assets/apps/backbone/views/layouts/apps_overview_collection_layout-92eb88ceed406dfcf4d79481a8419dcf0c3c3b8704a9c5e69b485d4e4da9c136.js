(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['/assets/apps/backbone/views/collection_views/cards_collection_view-49834ae498772f62874833130e327b481492dd605a728f25c803d65109cb83ae.js', '/assets/templates/apps/layouts/apps_overview_collection_layout-4b1a26255077f3146b3e4e67d227f66b387c24f6bb977a717253d0580901d00f.js', '/assets/apps/backbone/views/filter_view-837e67972e4f4d1bb3ae84fe89dd43463e30bd43eaa978e07200b37092654686.js', '/assets/apps/backbone/models/app-7bc75214fb94c799b83f2cc24f4c76f8372dfba0268346bdc794b7b5e959a8a9.js', 'jquery'], function(CardsCollectionView, Template, FilterView, App, $) {
    var AppsOverviewCollectionLayout;
    return AppsOverviewCollectionLayout = (function(_super) {

      __extends(AppsOverviewCollectionLayout, _super);

      function AppsOverviewCollectionLayout() {
        return AppsOverviewCollectionLayout.__super__.constructor.apply(this, arguments);
      }

      AppsOverviewCollectionLayout.prototype.template = HandlebarsTemplates['apps/layouts/apps_overview_collection_layout'];

      AppsOverviewCollectionLayout.prototype.regions = {
        filtersArea: '.filters',
        collectionArea: '.collection'
      };

      AppsOverviewCollectionLayout.prototype.renderRegions = function() {
        var appData, apps, collection;
        appData = $.parseJSON($('meta[name=apps]').attr('content'));
        apps = _.map(appData, function(attrs) {
          return new App(attrs);
        });
        collection = new Backbone.Collection(apps, {
          model: App
        });
        this.cardsView = new CardsCollectionView({
          collection: collection
        });
        this.collectionArea.show(this.cardsView);
        this.filterView = new FilterView({
          collectionView: this.cardsView,
          collection: collection
        });
        return this.filtersArea.show(this.filterView);
      };

      return AppsOverviewCollectionLayout;

    })(Backbone.Marionette.LayoutView);
  });

}).call(this);
