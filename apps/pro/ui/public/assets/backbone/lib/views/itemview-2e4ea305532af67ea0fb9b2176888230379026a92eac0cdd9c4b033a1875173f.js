
/*
From RequireJS Docs

The paths config was used to set two module IDs to the same file, and
that file only has one anonymous module in it. If module IDs "something"
and "lib/something" are both configured to point to the same "scripts/libs/something.js"
file, and something.js only has one anonymous module in it, this kind of timeout error
can occur. The fix is to make sure all module ID references use the same ID (either
choose "something" or "lib/something" for all references), or use map config.
*/


(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['/assets/shared/backbone/layouts/modal-57927538cf64c26b47a2f8f54fdef926ef3c906fba72986d69e71e13cfe4422f.js', 'base_view'], function(Modal) {
    return this.Pro.module("Views", function(Views, App, Backbone, Marionette, $, _) {
      return Views.ItemView = (function(_super) {

        __extends(ItemView, _super);

        function ItemView() {
          this.showDialog = __bind(this.showDialog, this);
          return ItemView.__super__.constructor.apply(this, arguments);
        }

        ItemView.prototype.showDialog = function(view, options) {
          var _this = this;
          if (this.modal) {
            this.modal.destroy();
          }
          this.modal = new Modal(options);
          this.modal.open();
          this.modal.content.show(view);
          this.modal._center();
          this.modal.content.$el.find('input, textarea').first().focus();
          return this.modal.content.$el.find('form').on('submit', function(e) {
            view.triggerMethod('dialog:button:primary:clicked');
            return _this.modal.destroy();
          });
        };

        return ItemView;

      })(Marionette.ItemView);
    });
  });

}).call(this);
