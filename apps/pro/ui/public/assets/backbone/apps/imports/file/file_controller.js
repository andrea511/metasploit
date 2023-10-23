(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'apps/imports/file/file_views', 'lib/components/file_input/file_input_controller'], function() {
    return this.Pro.module("ImportsApp.File", function(File, App) {
      File.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.initialize = function(options) {
          var _this = this;
          this.layout = new File.Layout();
          this.setMainView(this.layout);
          return this.listenTo(this._mainView, 'show', function() {
            _this.fileInput = App.request('file_input:component', {
              name: 'file'
            });
            return _this.show(_this.fileInput, {
              region: _this._mainView.fileInputRegion
            });
          });
        };

        Controller.prototype.useLastUploaded = function(fileName) {
          return this._mainView.useLastUploaded(fileName);
        };

        Controller.prototype.clearLastUploaded = function() {
          return this._mainView.clearLastUploaded();
        };

        return Controller;

      })(App.Controllers.Application);
      return App.reqres.setHandler('file:imports', function(options) {
        if (options == null) {
          options = {};
        }
        return new File.Controller(options);
      });
    });
  });

}).call(this);
