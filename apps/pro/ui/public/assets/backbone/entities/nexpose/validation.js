(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_model', 'base_collection'], function() {
    return this.Pro.module("Entities.Nexpose", function(Nexpose, App) {
      var API;
      Nexpose.Validation = (function(_super) {

        __extends(Validation, _super);

        function Validation() {
          this.urlRoot = __bind(this.urlRoot, this);
          return Validation.__super__.constructor.apply(this, arguments);
        }

        Validation.prototype.urlRoot = function() {
          return Routes.workspace_nexpose_result_validations_path(this.get('workspace_id'));
        };

        return Validation;

      })(App.Entities.Model);
      API = {
        getValidation: function(id) {
          return new Nexpose.Validation({
            id: id
          });
        },
        newValidation: function(attributes) {
          if (attributes == null) {
            attributes = {};
          }
          return new Nexpose.Validation(attributes);
        }
      };
      App.reqres.setHandler("nexpose:validation:entity", function(id) {
        return API.getValidation(id);
      });
      return App.reqres.setHandler("new:nexpose:validation:entity", function(attributes) {
        return API.newValidation(attributes);
      });
    });
  });

}).call(this);
