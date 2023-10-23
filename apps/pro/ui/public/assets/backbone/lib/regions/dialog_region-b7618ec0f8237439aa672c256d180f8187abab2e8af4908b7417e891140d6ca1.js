(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.Pro.module("Regions", function(Regions, App, Backbone, Marionette, $, _) {
    return Regions.Dialog = (function(_super) {

      __extends(Dialog, _super);

      function Dialog() {
        return Dialog.__super__.constructor.apply(this, arguments);
      }

      Dialog.prototype.onShow = function(view) {
        var options;
        this.setupBindings(view);
        options = this.getDefaultOptions(_.result(view, "dialog"));
        return this.openDialog(options);
      };

      Dialog.prototype.openDialog = function(options) {
        return this.$el;
      };

      Dialog.prototype.setupBindings = function(view) {
        return this.listenTo(view, "dialog:close", this.close);
      };

      Dialog.prototype.getDefaultOptions = function(options) {
        if (options == null) {
          options = {};
        }
        return _.defaults(options, {
          title: "default title"
        });
      };

      Dialog.prototype.onClose = function() {
        this.$el.off("closed");
        return this.stopListening();
      };

      return Dialog;

    })(Marionette.Region);
  });

}).call(this);
