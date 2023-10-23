(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'lib/shared/attempt_session/attempt_session_views', 'lib/shared/payload_settings/payload_settings_controller', 'entities/login'], function() {
    return this.Pro.module("Shared.AttemptSession", function(AttemptSession, App) {
      AttemptSession.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.initialize = function(options) {
          var model,
            _this = this;
          if (options == null) {
            options = {};
          }
          model = App.request("new:login:entity", options.model.toJSON());
          this.setMainView(new AttemptSession.ItemView({
            model: model
          }));
          return this.listenTo(this._mainView, 'btnClicked', function() {
            var _ref;
            if ((_ref = _this.payloadModel) == null) {
              _this.payloadModel = App.request('shared:payloadSettings:entities', {});
            }
            return App.execute('showModal', new Pro.Shared.PayloadSettings.Controller({
              model: _this.payloadModel
            }), {
              modal: {
                title: 'Payload Settings',
                description: '',
                width: 400,
                height: 330
              },
              buttons: [
                {
                  name: 'Close',
                  "class": 'close'
                }, {
                  name: 'OK',
                  "class": 'btn primary'
                }
              ],
              loading: true,
              doneCallback: function() {
                return _this._mainView.launchAttempt(_this.payloadModel);
              }
            });
          });
        };

        return Controller;

      })(App.Controllers.Application);
      return App.reqres.setHandler("attemptSession:shared", function(options) {
        if (options == null) {
          options = {};
        }
        return new AttemptSession.Controller(options);
      });
    });
  });

}).call(this);
