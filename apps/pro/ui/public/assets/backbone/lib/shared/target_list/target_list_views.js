(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'base_layout', 'base_compositeview', 'base_itemview', 'lib/shared/target_list/templates/layout'], function($) {
    return this.Pro.module("Shared.TargetList", function(TargetList, App, Backbone, Marionette, $, _) {
      return TargetList.Layout = (function(_super) {

        __extends(Layout, _super);

        function Layout() {
          this._numSelectedCreds = __bind(this._numSelectedCreds, this);

          this.updateSelectionCount = __bind(this.updateSelectionCount, this);

          this.updateClearState = __bind(this.updateClearState, this);
          return Layout.__super__.constructor.apply(this, arguments);
        }

        Layout.prototype.template = Layout.prototype.templatePath("target_list/layout");

        Layout.prototype.ui = {
          clear: 'a.clear',
          badge: 'span.badge'
        };

        Layout.prototype.regions = {
          targetListRegion: '.target-list'
        };

        Layout.prototype.triggers = {
          'click a.clear': 'removeTargets'
        };

        Layout.prototype.updateClearState = function(collection) {
          var _this = this;
          return _.defer(function() {
            var _ref;
            return (_ref = _this.ui.clear) != null ? _ref.toggle(_this._numSelectedCreds(collection) > 0) : void 0;
          });
        };

        Layout.prototype.updateSelectionCount = function(collection) {
          var _this = this;
          return _.defer(function() {
            var _ref;
            return (_ref = _this.ui.badge) != null ? _ref.toggle(_this._numSelectedCreds(collection) > 0).text(_this._numSelectedCreds(collection)) : void 0;
          });
        };

        Layout.prototype._numSelectedCreds = function(collection) {
          var _ref;
          return ((_ref = collection.ids) != null ? _ref.length : void 0) || 0;
        };

        return Layout;

      })(App.Views.Layout);
    });
  });

}).call(this);
