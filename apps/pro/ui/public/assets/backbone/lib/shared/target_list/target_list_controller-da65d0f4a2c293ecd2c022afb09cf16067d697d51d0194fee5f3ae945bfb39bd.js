(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'lib/shared/target_list/target_list_views', 'entities/target'], function() {
    return this.Pro.module("Shared.TargetList", function(TargetList, App) {
      return TargetList.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          this.selectionUpdated = __bind(this.selectionUpdated, this);
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.defaults = function() {};

        Controller.prototype.initialize = function(options) {
          var layout;
          if (options == null) {
            options = {};
          }
          this.targetListCollection = options.targetListCollection;
          layout = new TargetList.Layout();
          this.setMainView(layout);
          this.listenTo(this._mainView, 'show', function() {
            var _ref, _ref1,
              _this = this;
            this.lazyList = new App.Components.LazyList.Controller({
              collection: this.targetListCollection,
              region: this._mainView.targetListRegion,
              childView: App.Shared.Targets.Target,
              ids: this.targetListCollection.ids || [],
              modelsLoaded: ((_ref = this.targetListCollection) != null ? (_ref1 = _ref.modelsLoaded) != null ? _ref1.length : void 0 : void 0) || 0
            });
            this.listenTo(this.targetListCollection, 'add', this.selectionUpdated);
            this.listenTo(this.targetListCollection, 'remove', this.selectionUpdated);
            this.listenTo(this.targetListCollection, 'reset', this.selectionUpdated);
            return _.defer(function() {
              return _this.selectionUpdated();
            });
          });
          return this.listenTo(this._mainView, 'removeTargets', function() {
            var result;
            result = confirm("Are you sure you want to remove all targets?");
            if (result) {
              return this.targetListCollection.reset();
            }
          });
        };

        Controller.prototype.selectionUpdated = function() {
          this._mainView.updateClearState(this.targetListCollection);
          return this._mainView.updateSelectionCount(this.targetListCollection);
        };

        return Controller;

      })(App.Controllers.Application);
    });
  });

}).call(this);
