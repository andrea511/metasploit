(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'base_compositeview', 'base_itemview', 'base_layout', 'lib/components/lazy_list/lazy_list_collection', 'lib/components/lazy_list/templates/list', 'lib/components/lazy_list/templates/load_more', 'lib/components/lazy_list/templates/layout'], function($) {
    return this.Pro.module("Components.LazyList", function(LazyList, App) {
      LazyList.Layout = (function(_super) {

        __extends(Layout, _super);

        function Layout() {
          this.resetScroller = __bind(this.resetScroller, this);
          return Layout.__super__.constructor.apply(this, arguments);
        }

        Layout.prototype.template = Layout.prototype.templatePath('lazy_list/layout');

        Layout.prototype.attributes = {
          "class": 'lazy-list-component nano'
        };

        Layout.prototype.regions = {
          list: '.list',
          loadMore: '.load-more'
        };

        Layout.prototype.onShow = function() {
          this.$el.css('height', this.$el.height());
          return this.$el.nanoScroller();
        };

        Layout.prototype.resetScroller = function() {
          return this.$el.nanoScroller();
        };

        Layout.prototype.onDestroy = function() {
          return this.$el.nanoScroller({
            destroy: true
          });
        };

        return Layout;

      })(App.Views.Layout);
      LazyList.LoadMore = (function(_super) {

        __extends(LoadMore, _super);

        function LoadMore() {
          this.initialize = __bind(this.initialize, this);
          return LoadMore.__super__.constructor.apply(this, arguments);
        }

        LoadMore.prototype.template = LoadMore.prototype.templatePath('lazy_list/load_more');

        LoadMore.prototype.triggers = {
          click: 'loadMoreClicked'
        };

        LoadMore.prototype.attributes = {
          "class": 'load-more'
        };

        LoadMore.prototype.loadMoreLabel = "Load More";

        LoadMore.prototype.initialize = function(_arg) {
          var loadMoreLabel, modelsLoaded,
            _this = this;
          this.collection = _arg.collection, loadMoreLabel = _arg.loadMoreLabel, modelsLoaded = _arg.modelsLoaded;
          this.collection.modelsLoaded = modelsLoaded || this.collection.modelsLoaded;
          this.loadMoreLabel = loadMoreLabel || this.loadMoreLabel;
          this.listenTo(this.collection, 'fetched', function() {
            return _.defer(_this.render);
          });
          return this.listenTo(this.collection, 'reset', function() {
            return _.defer(_this.render);
          });
        };

        LoadMore.prototype.serializeData = function() {
          return this;
        };

        return LoadMore;

      })(App.Views.ItemView);
      LazyList.EmptyView = (function(_super) {

        __extends(EmptyView, _super);

        function EmptyView() {
          return EmptyView.__super__.constructor.apply(this, arguments);
        }

        EmptyView.prototype.attributes = {
          "class": 'empty-view'
        };

        EmptyView.prototype.template = function() {
          return 'Nothing is selected.';
        };

        return EmptyView;

      })(App.Views.ItemView);
      return LazyList.List = (function(_super) {

        __extends(List, _super);

        function List() {
          this.setLoading = __bind(this.setLoading, this);

          this.loadingMore = __bind(this.loadingMore, this);

          this.fetched = __bind(this.fetched, this);

          this.buildChildView = __bind(this.buildChildView, this);
          return List.__super__.constructor.apply(this, arguments);
        }

        List.prototype.template = List.prototype.templatePath('lazy_list/list');

        List.prototype.childView = App.Views.ItemView;

        List.prototype.emptyView = LazyList.EmptyView;

        List.prototype.childViewContainer = '.stuff';

        List.prototype.attributes = {
          "class": 'lazy-list collection-loading'
        };

        List.prototype.collectionEvents = {
          fetched: 'fetched',
          loadingMore: 'loadingMore'
        };

        List.prototype.loading = true;

        List.prototype.buildChildView = function(item, ItemViewType, itemViewOptions) {
          var opts;
          opts = _.extend({
            model: item,
            collection: this.collection
          }, itemViewOptions);
          return new ItemViewType(opts);
        };

        List.prototype.initialize = function(opts) {
          if (opts == null) {
            opts = {};
          }
          _.extend(this, _.pick(opts, 'childView', 'loadMoreLabel', 'collection'));
          Cocktail.mixin(this.collection, App.Concerns.LazyListCollection);
          return this.collection.initializeLaziness(opts);
        };

        List.prototype.showEmptyView = function() {
          return List.__super__.showEmptyView.apply(this, arguments);
        };

        List.prototype.fetched = function() {
          return this.setLoading(false);
        };

        List.prototype.loadingMore = function() {
          return this.setLoading(true);
        };

        List.prototype.setLoading = function(loading) {
          this.loading = loading;
          this.$el.toggleClass('collection-loading', loading);
          return this.loading;
        };

        List.prototype.serializeData = function() {
          return this;
        };

        return List;

      })(App.Views.CompositeView);
    });
  });

}).call(this);
