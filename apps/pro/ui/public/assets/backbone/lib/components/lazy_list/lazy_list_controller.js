(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'lib/components/lazy_list/lazy_list_view'], function() {
    return this.Pro.module('Components.LazyList', function(LazyList, App) {
      LazyList.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          this.addIDs = __bind(this.addIDs, this);

          this.resize = __bind(this.resize, this);
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.collection = null;

        Controller.prototype.loadMoreView = null;

        Controller.prototype.listView = null;

        Controller.prototype.initialize = function(opts) {
          var _this = this;
          if (opts == null) {
            opts = {};
          }
          _.extend(this, _.pick(opts, 'collection'));
          _.defaults(opts, {
            show: true
          });
          this.layout = new LazyList.Layout;
          this.setMainView(this.layout);
          this.listView = new LazyList.List(opts);
          this.loadMoreView = new LazyList.LoadMore(opts);
          this.listenTo(this.layout, 'show', function() {
            _this.show(_this.listView, {
              region: _this.layout.list,
              preventDestroy: true
            });
            _this.show(_this.loadMoreView, {
              region: _this.layout.loadMore,
              preventDestroy: true
            });
            if (!(_this.collection.currPage > 0 || !(opts.ids != null) || opts.ids.length < 1)) {
              return _this.collection.loadMore();
            } else {
              return _this.collection.trigger('fetched');
            }
          });
          this.listenTo(this.loadMoreView, 'loadMoreClicked', function() {
            _this.collection.loadMore();
            return _this.listView.setLoading(true);
          });
          this.listenTo(this.collection, 'fetched reset', function() {
            return _.defer(_this.layout.resetScroller);
          });
          if (opts.show) {
            return this.show(this.layout, {
              region: opts.region
            });
          }
        };

        Controller.prototype.resize = function() {
          return this.layout.resetScroller();
        };

        Controller.prototype.addIDs = function(ids) {
          if ((ids != null ? ids.length : void 0) > 0) {
            this.collection.addIDs(ids);
            return this.collection.loadMore();
          }
        };

        return Controller;

      })(App.Controllers.Application);
      return App.reqres.setHandler('lazy_list:component', function(options) {
        if (options == null) {
          options = {};
        }
        return new LazyList.Controller(options);
      });
    });
  });

}).call(this);
