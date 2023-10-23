(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'lib/components/pro_search_filter/filter_view'], function() {
    return this.Pro.module("Components.ProSearchFilter", function(ProSearchFilter, App) {
      ProSearchFilter.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.defaults = function() {
          return {
            placeHolderText: 'Search...'
          };
        };

        Controller.prototype.initialize = function(options) {
          if (options == null) {
            options = {};
          }
          this.filterView = this.getFilterView(options);
          this.setMainView(this.filterView);
          return this.listenTo(this.filterView, 'pro:search:filter:query:new', function(query) {
            return this.trigger('pro:search:filter:query:new', query);
          });
        };

        Controller.prototype.getFilterView = function(options) {
          return new ProSearchFilter.FilterView(options);
        };

        return Controller;

      })(App.Controllers.Application);
      return App.reqres.setHandler("pro:search:filter:component", function(options) {
        if (options == null) {
          options = {};
        }
        return new ProSearchFilter.Controller(options);
      });
    });
  });

}).call(this);
