(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'lib/shared/nexpose_console/nexpose_console_views', 'entities/nexpose/console', 'css!css/shared/nexpose_console'], function() {
    return this.Pro.module("Shared.NexposeConsole", function(NexposeConsole, App, Backbone, Marionette, $, _) {
      var CONNECTION_CONFIRM_MSG;
      CONNECTION_CONFIRM_MSG = 'Unable to connect to the Nexpose instance. ' + 'Would you like to save the Nexpose Console anyways?';
      NexposeConsole.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.initialize = function(options) {
          if (options == null) {
            options = {};
          }
          this.model = App.request('new:nexpose:console:entity');
          return this.setMainView(new NexposeConsole.Form());
        };

        Controller.prototype.onFormSubmit = function() {
          var callbacks, defer, formData,
            _this = this;
          defer = $.Deferred();
          defer.promise();
          callbacks = {
            success: function(model, response, options) {
              var json;
              json = response;
              if (!json.connection_success && json.message.match(/API error/)) {
                _this.trigger("btn:enable:modal", "Connect To Nexpose");
                _this._mainView.setLoading(false);
                _this._mainView.showErrors({
                  'password': ['is incorrect']
                });
                return new _this.model.constructor({
                  id: json.id
                }).destroy();
              } else {
                _this._mainView.setLoading(false);
                _this._mainView.toggleConnectionStatus(json.connection_success);
                if (json.connection_success) {
                  _this._mainView.clearErrors();
                  _this.trigger('consoleAdded:nexposeConsole', json);
                  return setTimeout((function() {
                    return defer.resolve();
                  }), 800);
                } else {
                  if (confirm(CONNECTION_CONFIRM_MSG)) {
                    return defer.resolve();
                  } else {
                    _this.trigger("btn:enable:modal", "Connect To Nexpose");
                    return new _this.model.constructor({
                      id: json.id
                    }).destroy();
                  }
                }
              }
            },
            error: function(model, response, options) {
              _this.trigger("btn:enable:modal", "Connect To Nexpose");
              _this._mainView.setLoading(false);
              return _this._mainView.showErrors(response.responseJSON.errors);
            }
          };
          this.model.clear();
          formData = Backbone.Syphon.serialize(this._mainView);
          this.model.set(formData.nexpose_console);
          this._mainView.setLoading(true);
          this.trigger("btn:disable:modal", "Connect To Nexpose");
          this.model.save({}, callbacks);
          return defer;
        };

        return Controller;

      })(App.Controllers.Application);
      App.reqres.setHandler("nexposeConsole:shared", function(options) {
        if (options == null) {
          options = {};
        }
        return new NexposeConsole.Controller(options);
      });
      return App.commands.setHandler('show:nexposeConsole', function(consoleController) {
        return App.execute('showModal', consoleController, {
          modal: {
            title: 'Configure Nexpose Console',
            description: '',
            width: 600,
            "class": 'no-border'
          },
          buttons: [
            {
              name: 'Cancel',
              "class": 'close'
            }, {
              name: 'Connect To Nexpose',
              "class": 'btn primary'
            }
          ]
        });
      });
    });
  });

}).call(this);
