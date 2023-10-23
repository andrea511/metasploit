(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'base_model', 'lib/entities/abstract/tab', 'lib/components/tabs/tabs_view'], function() {
    return this.Pro.module("Components.Tabs", function(Tabs, App, Backbone, Marionette, $, _) {
      Tabs.TabsController = (function(_super) {

        __extends(TabsController, _super);

        function TabsController() {
          return TabsController.__super__.constructor.apply(this, arguments);
        }

        TabsController.prototype.defaults = function() {
          return {
            tabs: [],
            destroy: true
          };
        };

        TabsController.prototype.initialize = function(opts) {
          var models,
            _this = this;
          if (opts == null) {
            opts = {};
          }
          this.config = _.defaults(opts, this._getDefaults());
          this.setMainView(new Tabs.Layout());
          models = _.map(this.config.tabs, function(tab) {
            return App.request('component:tab:entity', tab);
          });
          this.collection = App.request('component:tab:entities', models);
          this.listenTo(this._mainView, 'show', function() {
            var collectionView;
            collectionView = new Tabs.TabCollection({
              collection: _this.collection
            });
            _this.show(collectionView, {
              region: _this._mainView.tabs
            });
            return _this.collection.at(0).choose();
          });
          if (this.config.destroy) {
            return this.initTabSwap();
          } else {
            return this.initTabSwapSimple();
          }
        };

        TabsController.prototype.initTabSwap = function() {
          return this.listenTo(this.collection, "collection:chose:one", function(chosen) {
            var View, view;
            View = chosen.get('view');
            view = new View({
              model: chosen.get('model'),
              options: chosen.get('options')
            });
            return this.show(view, {
              region: this._mainView.tabContent
            });
          });
        };

        TabsController.prototype.initTabSwapSimple = function() {
          return this.listenTo(this.collection, "collection:chose:one", function(chosen) {
            var View, view;
            if (!chosen.get('cachedView')) {
              View = chosen.get('view');
              view = new View({
                model: chosen.get('model'),
                options: chosen.get('options')
              });
              chosen.set('cachedView', view);
              return this._showView(view);
            } else {
              view = chosen.get('cachedView');
              return this._showView(view);
            }
          });
        };

        TabsController.prototype._showView = function(view) {
          var id;
          id = view.cid;
          if (this._mainView.getRegion(id)) {
            $('>div', this._mainView.ui.tabContent).hide();
            return this._mainView.getRegion(id).$el.show();
          } else {
            this._mainView.ui.tabContent.append("<div class='" + id + "'></div>");
            this._mainView.addRegion(id, "." + id);
            this.show(view, {
              region: this._mainView.getRegion(id)
            });
            $('>div', this._mainView.ui.tabContent).hide();
            return this._mainView.getRegion(id).$el.show();
          }
        };

        TabsController.prototype.setInvalidTabs = function(tabIdx) {
          var tabId, _i, _len, _results;
          if (tabIdx == null) {
            tabIdx = [];
          }
          _results = [];
          for (_i = 0, _len = tabIdx.length; _i < _len; _i++) {
            tabId = tabIdx[_i];
            _results.push(this.collection.at(tabId).set('valid', false));
          }
          return _results;
        };

        TabsController.prototype.resetValidTabs = function() {
          return this.collection.each(function(tab) {
            return tab.set('valid', true);
          });
        };

        return TabsController;

      })(App.Controllers.Application);
      return App.reqres.setHandler('tabs:component', function(opts) {
        if (opts == null) {
          opts = {};
        }
        return new Tabs.TabsController(opts);
      });
    });
  });

}).call(this);
