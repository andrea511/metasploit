(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'lib/shared/payload_settings/payload_settings_views', 'entities/shared/payload_settings'], function() {
    return this.Pro.module("Shared.PayloadSettings", function(PayloadSettings, App, Backbone, Marionette, $, _) {
      return PayloadSettings.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.defaults = function() {};

        Controller.prototype.initialize = function(options) {
          var layout;
          if (options == null) {
            options = {};
          }
          this.model = options.model;
          this.model = this.model || App.request('shared:payloadSettings:entities');
          layout = new PayloadSettings.View({
            model: this.model
          });
          this.setMainView(layout);
          this.model.fetch();
          return this.listenTo(this._mainView, 'show', function() {
            return Backbone.Syphon.deserialize(this._mainView, this.model.toJSON());
          });
        };

        Controller.prototype.onFormSubmit = function() {
          var defer,
            _this = this;
          defer = $.Deferred();
          defer.promise();
          this._serializeForm();
          this.model.save({}, {
            success: function() {
              _this.model.set({
                validated: true
              });
              return defer.resolve();
            },
            error: function(payloadSettings, response) {
              _this._mainView.updateErrors(response.responseJSON);
              return _this.model.unset('validated');
            }
          });
          return defer;
        };

        Controller.prototype._serializeForm = function() {
          return this.model.set(Backbone.Syphon.serialize(this._mainView));
        };

        return Controller;

      })(App.Controllers.Application);
    });
  });

}).call(this);
