(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'lib/shared/nexpose_push/nexpose_push_started_view'], function() {
    return this.Pro.module("Shared.NexposePush", function(NexposePush, App, Backbone, Marionette, $, _) {
      return NexposePush.StartedController = (function(_super) {

        __extends(StartedController, _super);

        function StartedController() {
          return StartedController.__super__.constructor.apply(this, arguments);
        }

        StartedController.prototype.initialize = function(opts) {
          _.defaults(opts, {
            title: 'Push To Nexpose',
            buttons: [
              {
                name: 'OK',
                "class": 'btn primary close'
              }
            ]
          });
          this.buttons = opts.buttons, this.title = opts.title, this.redirectUrl = opts.redirectUrl;
          this.model = new Backbone.Model({
            redirectUrl: this.redirectUrl
          });
          return this.setMainView(this._getModalView());
        };

        StartedController.prototype._getModalView = function() {
          return this.modalView = this.modalView || new NexposePush.StartedView({
            model: this.model
          });
        };

        StartedController.prototype.showModal = function() {
          var errorCallback, modalOptions;
          modalOptions = {
            modal: {
              title: this.title,
              hideBorder: true,
              width: 400
            },
            buttons: this.buttons
          };
          errorCallback = function(data) {
            throw "Error with vulns:push:started";
          };
          jQuery("a.nexpose").removeClass('submitting');
          return App.execute("showModal", this, modalOptions, errorCallback);
        };

        return StartedController;

      })(App.Controllers.Application);
    });
  });

}).call(this);
