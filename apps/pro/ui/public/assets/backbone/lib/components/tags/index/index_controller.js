(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'base_controller', 'lib/components/tags/index/index_view'], function($) {
    return this.Pro.module("Components.Tags.Index", function(Index, App, Backbone, Marionette, $, _) {
      Index.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.initialize = function(options) {
          var _this = this;
          this.model = options.model, this.serverAPI = options.serverAPI;
          this.setMainView(new Index.Layout({
            model: this.model
          }));
          this.listenTo(this._mainView, 'show', function() {
            _this.tagCompositeView = new Index.TagCompositeView({
              model: _this.model,
              serverAPI: _this.serverAPI
            });
            _this.listenTo(_this.tagCompositeView, 'tag:increment', function(count) {
              return this._mainView.increment(count);
            });
            _this.listenTo(_this.tagCompositeView, 'tag:decrement', function() {
              return this._mainView.decrement();
            });
            return _this.show(_this.tagCompositeView, {
              region: _this._mainView.tagHover
            });
          });
          this.listenTo(this._mainView, 'show:tag:hover', function() {
            this.tagCompositeView.clearTagHovers();
            return this.tagCompositeView.showTags();
          });
          return this.listenTo(this._mainView, 'hide:tag:hover', function() {
            return this.tagCompositeView.hideTags();
          });
        };

        return Controller;

      })(App.Controllers.Application);
      return App.reqres.setHandler('tags:index:component', function(options) {
        if (options == null) {
          options = {};
        }
        if (options.instantiate != null) {
          return new Index.Controller(options);
        } else {
          return Index.Controller;
        }
      });
    });
  });

}).call(this);
