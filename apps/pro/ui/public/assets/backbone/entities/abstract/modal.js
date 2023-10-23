(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_model'], function() {
    return this.Pro.module("Entities", function(Entities, App, Backbone, Marionette, jQuery, _) {
      var API;
      Entities.Modal = (function(_super) {

        __extends(Modal, _super);

        function Modal() {
          return Modal.__super__.constructor.apply(this, arguments);
        }

        Modal.prototype.defaults = {
          title: "Default Title",
          description: ""
        };

        return Modal;

      })(Entities.Model);
      API = {
        getModal: function(options) {
          if (options == null) {
            options = {};
          }
          return new Entities.Modal(options);
        }
      };
      return App.reqres.setHandler("component:modal:entities", function(options) {
        if (options == null) {
          options = {};
        }
        return API.getModal(options);
      });
    });
  });

}).call(this);
