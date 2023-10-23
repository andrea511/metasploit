(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_model', 'base_collection'], function() {
    return this.Pro.module("Entities.Shared", function(Shared, App) {
      var API;
      Shared.PayloadSettings = (function(_super) {

        __extends(PayloadSettings, _super);

        function PayloadSettings() {
          return PayloadSettings.__super__.constructor.apply(this, arguments);
        }

        PayloadSettings.prototype.defaults = {
          PAYLOAD_TYPE: ["Meterpreter", "Meterpreter 64-bit", "Command shell", "Powershell"],
          CONNECTION_TYPE: ["Auto", "Reverse", "Bind"],
          payload_settings: {
            payload_type: 'Meterpreter',
            connection_type: 'Auto',
            listener_ports: '1024-65535'
          }
        };

        PayloadSettings.prototype.url = function() {
          return Routes.workspace_shared_payload_settings_path(WORKSPACE_ID) + '.json';
        };

        return PayloadSettings;

      })(App.Entities.Model);
      API = {
        getPayloadSettings: function(opts) {
          return new Shared.PayloadSettings(opts);
        }
      };
      return App.reqres.setHandler("shared:payloadSettings:entities", function(opts) {
        if (opts == null) {
          opts = {};
        }
        return API.getPayloadSettings(opts);
      });
    });
  });

}).call(this);
