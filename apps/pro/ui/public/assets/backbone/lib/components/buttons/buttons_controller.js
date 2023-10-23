(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'lib/components/buttons/buttons_view', 'entities/abstract/buttons'], function() {
    return this.Pro.module("Components.Buttons", function(Buttons, App, Backbone, Marionette, $, _) {
      Buttons.ButtonsController = (function(_super) {

        __extends(ButtonsController, _super);

        function ButtonsController() {
          return ButtonsController.__super__.constructor.apply(this, arguments);
        }

        ButtonsController.prototype.defaults = function() {
          return {
            buttons: [
              {
                name: 'Cancel',
                "class": 'close'
              }, {
                name: 'Submit',
                "class": 'btn primary'
              }
            ]
          };
        };

        ButtonsController.prototype.initialize = function(options) {
          var buttons;
          if (options == null) {
            options = {};
          }
          this.config = _.defaults(options, this._getDefaults());
          buttons = this.getButtons(this.config.buttons);
          this.collectionView = this.getCollectionView(buttons);
          return this.setMainView(this.collectionView);
        };

        ButtonsController.prototype.getCollectionView = function(buttons) {
          return new Buttons.ButtonCollectionView({
            collection: buttons
          });
        };

        ButtonsController.prototype.getButtons = function(buttons) {
          return App.request("buttons:entities", buttons);
        };

        ButtonsController.prototype.disableBtn = function(btnName) {
          return this.findBtn(btnName).addClass('disabled');
        };

        ButtonsController.prototype.enableBtn = function(btnName) {
          return this.findBtn(btnName).removeClass('disabled');
        };

        ButtonsController.prototype.findBtn = function(btnName) {
          var btn, selector;
          btn = _.findWhere(this.config.buttons, {
            name: btnName
          });
          if (!btn) {
            throw "Button '" + btnName + "' not found in modal";
          }
          selector = "." + (btn["class"].replace(' ', '.'));
          return $(selector, this.el);
        };

        return ButtonsController;

      })(App.Controllers.Application);
      return App.reqres.setHandler("buttons:component", function(options) {
        if (options == null) {
          options = {};
        }
        return new Buttons.ButtonsController(options);
      });
    });
  });

}).call(this);
