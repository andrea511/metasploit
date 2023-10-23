(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_collectionview', 'base_itemview', 'lib/components/buttons/templates/button'], function($) {
    return this.Pro.module("Components.Buttons", function(Buttons, App) {
      Buttons.ButtonView = (function(_super) {

        __extends(ButtonView, _super);

        function ButtonView() {
          return ButtonView.__super__.constructor.apply(this, arguments);
        }

        ButtonView.prototype.template = ButtonView.prototype.templatePath("buttons/button");

        ButtonView.prototype.className = 'inline-block';

        return ButtonView;

      })(App.Views.ItemView);
      return Buttons.ButtonCollectionView = (function(_super) {

        __extends(ButtonCollectionView, _super);

        function ButtonCollectionView() {
          return ButtonCollectionView.__super__.constructor.apply(this, arguments);
        }

        ButtonCollectionView.prototype.childView = Buttons.ButtonView;

        return ButtonCollectionView;

      })(App.Views.CollectionView);
    });
  });

}).call(this);
