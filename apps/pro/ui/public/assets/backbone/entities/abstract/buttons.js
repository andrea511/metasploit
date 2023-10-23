(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_model', 'base_collection'], function() {
    return this.Pro.module("Entities", function(Entities, App, Backbone, Marionette, jQuery, _) {
      var API;
      Entities.Button = (function(_super) {

        __extends(Button, _super);

        function Button() {
          return Button.__super__.constructor.apply(this, arguments);
        }

        Button.prototype.defaults = {
          buttonType: "button"
        };

        return Button;

      })(Entities.Model);
      Entities.ButtonCollection = (function(_super) {

        __extends(ButtonCollection, _super);

        function ButtonCollection() {
          return ButtonCollection.__super__.constructor.apply(this, arguments);
        }

        ButtonCollection.prototype.model = Entities.Button;

        return ButtonCollection;

      })(Entities.Collection);
      API = {
        getFormButtons: function(buttons) {
          var buttonCollection;
          buttonCollection = new Entities.ButtonCollection([]);
          buttonCollection.reset(buttons);
          return buttonCollection;
        }
      };
      return App.reqres.setHandler("buttons:entities", function(buttons) {
        if (buttons == null) {
          buttons = {};
        }
        return API.getFormButtons(buttons);
      });
    });
  });

}).call(this);
