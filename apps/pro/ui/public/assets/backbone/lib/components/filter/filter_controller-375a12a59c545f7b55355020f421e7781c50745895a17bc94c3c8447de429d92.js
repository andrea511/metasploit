(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'lib/components/filter/filter_view', 'css!css/components/filter', 'lib/components/flash/flash_controller'], function() {
    return this.Pro.module("Components.Filter", function(Filter, App) {
      Filter.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.defaults = function() {
          return {};
        };

        Controller.prototype.initialize = function(options) {
          if (options == null) {
            options = {};
          }
          this.filterView = this.getFilterView(options);
          this.setMainView(this.filterView);
          return this.listenTo(this.filterView, 'filter:query:new', function(query) {
            return this.trigger('filter:query:new', query);
          });
        };

        Controller.prototype.getFilterView = function(options) {
          return new Filter.FilterView(options);
        };

        return Controller;

      })(App.Controllers.Application);
      return App.reqres.setHandler("filter:component", function(options) {
        if (options == null) {
          options = {};
        }
        return new Filter.Controller(options);
      });
    });
  });

}).call(this);
