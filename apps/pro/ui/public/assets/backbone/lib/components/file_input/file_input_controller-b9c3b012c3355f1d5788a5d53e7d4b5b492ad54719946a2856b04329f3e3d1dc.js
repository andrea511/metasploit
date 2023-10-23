(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'lib/components/file_input/file_input_views'], function() {
    return this.Pro.module("Components.FileInput", function(FileInput, App, Backbone, Marionette, $, _) {
      FileInput.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.defaults = function() {
          return {
            name: "file_input[data]"
          };
        };

        Controller.prototype.initialize = function(options) {
          var config;
          config = _.defaults(options, this._getDefaults());
          this.layout = new FileInput.Input({
            model: new Backbone.Model(config)
          });
          return this.setMainView(this.layout);
        };

        Controller.prototype.rebindFileInput = function() {
          this._mainView.bindUIElements();
          this._mainView.undelegateEvents();
          return this._mainView.delegateEvents();
        };

        Controller.prototype.resetLabel = function() {
          return this._mainView.resetLabel();
        };

        Controller.prototype.clear = function() {
          return this._mainView.clearInput();
        };

        Controller.prototype.isFileSet = function() {
          return this._mainView.isFileSet();
        };

        return Controller;

      })(App.Controllers.Application);
      return App.reqres.setHandler('file_input:component', function(options) {
        if (options == null) {
          options = {};
        }
        return new FileInput.Controller(options);
      });
    });
  });

}).call(this);
