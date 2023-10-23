(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'base_layout', 'base_compositeview', 'base_itemview', 'lib/shared/payload_settings/templates/view'], function($) {
    return this.Pro.module("Shared.PayloadSettings", function(PayloadSettings, App, Backbone, Marionette, $, _) {
      return PayloadSettings.View = (function(_super) {

        __extends(View, _super);

        function View() {
          return View.__super__.constructor.apply(this, arguments);
        }

        View.prototype.template = View.prototype.templatePath("payload_settings/view");

        View.prototype.className = 'payload-settings';

        View.prototype.updateErrors = function(response) {
          var _this = this;
          $('.error', this.el).remove();
          return _.each(response.errors, function(v, k) {
            var $msg;
            $msg = $('<div />', {
              "class": 'error'
            }).text(v);
            return $("[name='payload_settings[" + k + "]']", _this.el).addClass('invalid').after($msg);
          });
        };

        return View;

      })(App.Views.ItemView);
    });
  });

}).call(this);
