(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'lib/components/tooltip/tooltip_views'], function() {
    return this.Pro.module("Components.Tooltip", function(Tooltip, App) {
      Tooltip.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.defaults = function() {
          return {
            title: 'Title',
            content: 'Default Content'
          };
        };

        Controller.prototype.initialize = function(options) {
          var config, model, view;
          if (options == null) {
            options = {};
          }
          config = _.defaults(options, this._getDefaults());
          model = new Backbone.Model(config);
          view = new Tooltip.View();
          model.set('cid', view.cid);
          model.set('informationAssetTag', '<img src="/assets/icons/silky/information-c0210a97250ec34cc04d6c8ff768012bf9e054abe33c7fcc558f65bf57a1661a.png" />');
          view.model = model;
          if (config.view != null) {
            this.listenTo(this._mainView, 'show', function() {
              return this.show(config.view, {
                region: this._mainView.contentRegion
              });
            });
          }
          return this.setMainView(view);
        };

        return Controller;

      })(App.Controllers.Application);
      return App.reqres.setHandler('tooltip:component', function(options) {
        if (options == null) {
          options = {};
        }
        return new Tooltip.Controller(options);
      });
    });
  });

}).call(this);
