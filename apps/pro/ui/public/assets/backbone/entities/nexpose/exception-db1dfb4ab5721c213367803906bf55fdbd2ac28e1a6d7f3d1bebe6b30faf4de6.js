(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_model', 'base_collection'], function() {
    return this.Pro.module("Entities.Nexpose", function(Nexpose, App) {
      var API;
      Nexpose.Exception = (function(_super) {

        __extends(Exception, _super);

        function Exception() {
          this.urlRoot = __bind(this.urlRoot, this);
          return Exception.__super__.constructor.apply(this, arguments);
        }

        Exception.REASON = {
          "false_positive": "False Positive",
          "compensating_control": "Compensating Control",
          "acceptable_risk": "Acceptable Risk",
          "acceptible_use": "Acceptable Use",
          "other": "Other"
        };

        Exception.prototype.defaults = {
          reasons: {
            "false_positive": "False Positive",
            "compensating_control": "Compensating Control",
            "acceptable_risk": "Acceptable Risk",
            "acceptible_use": "Acceptable Use",
            "other": "Other"
          },
          reasonsJSON: '{"false_positive":"False Positive","compensating_control":"Compensating Control","acceptable_risk":"Acceptable Risk","acceptible_use":"Acceptable Use","other":"Other"}'
        };

        Exception.prototype.mutators = {
          reasons: function() {
            return JSON.parse(this.get('reasonsJSON'));
          }
        };

        Exception.prototype.urlRoot = function() {
          return Routes.workspace_nexpose_result_exceptions_path(this.get('workspace_id'));
        };

        return Exception;

      })(App.Entities.Model);
      API = {
        getException: function(id) {
          return new Nexpose.Exception({
            id: id
          });
        },
        newException: function(attributes) {
          if (attributes == null) {
            attributes = {};
          }
          return new Nexpose.Exception(attributes);
        }
      };
      App.reqres.setHandler("nexpose:exception:entity", function(id) {
        return API.getException(id);
      });
      return App.reqres.setHandler("new:nexpose:exception:entity", function(attributes) {
        return API.newException(attributes);
      });
    });
  });

}).call(this);
