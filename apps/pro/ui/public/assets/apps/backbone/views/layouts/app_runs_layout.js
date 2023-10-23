(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['/assets/templates/apps/layouts/app_runs_layout-2368ce1e012e693841a2e3ed5419e55ff5b0c9672f9f69eabdd2f4a1aeda5861.js', '/assets/apps/backbone/views/collection_views/app_runs_collection_view-679b255f4a44ec6ab54132e1adbceac1dfe15fca25ff0c8952daf07bded47739.js', '/assets/apps/backbone/collections/app_runs_collection-d4014baae99272a7068d24664e8a5d3105f3ea51fb11956ef85127a4982a1011.js'], function(Template, AppRunsCollectionView, AppRunsCollection) {
    var AppsOverviewLayout;
    return AppsOverviewLayout = (function(_super) {

      __extends(AppsOverviewLayout, _super);

      function AppsOverviewLayout() {
        this.fetchForever = __bind(this.fetchForever, this);

        this.renderRegions = __bind(this.renderRegions, this);
        return AppsOverviewLayout.__super__.constructor.apply(this, arguments);
      }

      AppsOverviewLayout.POLL_INTERVAL = 1000 * 9;

      AppsOverviewLayout.prototype.template = HandlebarsTemplates['apps/layouts/app_runs_layout'];

      AppsOverviewLayout.prototype.regions = {
        collectionArea: '.collection-area'
      };

      AppsOverviewLayout.prototype.renderRegions = function() {
        var collection;
        collection = new AppRunsCollection();
        this.collectionView = new AppRunsCollectionView({
          collection: collection
        });
        this.collectionArea.show(this.collectionView);
        return this.fetchForever(collection);
      };

      AppsOverviewLayout.prototype.fetchForever = function(collection) {
        var _this = this;
        return collection.fetch({
          success: function() {
            return window.setTimeout((function() {
              return _this.fetchForever(collection);
            }), AppsOverviewLayout.POLL_INTERVAL);
          }
        });
      };

      return AppsOverviewLayout;

    })(Backbone.Marionette.LayoutView);
  });

}).call(this);
