(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'base_layout', 'base_compositeview', 'base_itemview', 'lib/shared/nexpose_console/templates/form'], function($) {
    return this.Pro.module("Shared.NexposeConsole", function(NexposeConsole, App) {
      return NexposeConsole.Form = (function(_super) {

        __extends(Form, _super);

        function Form() {
          this.setLoading = __bind(this.setLoading, this);

          this._errorDiv = __bind(this._errorDiv, this);

          this.showErrors = __bind(this.showErrors, this);
          return Form.__super__.constructor.apply(this, arguments);
        }

        Form.prototype.template = Form.prototype.templatePath("nexpose_console/form");

        Form.prototype.toggleConnectionStatus = function(connection_success) {
          $('.connectivity .connection_success', this.el).toggle(connection_success);
          return $('.connectivity .connection_error', this.el).toggle(!connection_success);
        };

        Form.prototype.clearErrors = function() {
          $('.error', this.el).removeClass('error');
          return $('p.inline-error', this.el).remove();
        };

        Form.prototype.showErrors = function(errors) {
          var _this = this;
          this.clearErrors();
          return _.each(errors, function(v, k) {
            var $input;
            $input = $("[name*='[" + k + "]']", _this.el);
            $input.parents('li').first().addClass('error');
            return $input.parent().append(_this._errorDiv(v));
          });
        };

        Form.prototype._errorDiv = function(msg) {
          return $('<p />', {
            "class": 'inline-error'
          }).text(msg);
        };

        Form.prototype.setLoading = function(loading) {
          $(this.el).toggleClass('tab-loading', loading);
          if (loading) {
            return $('>*', this.el).css({
              opacity: 0.2,
              'pointer-events': 'none'
            });
          } else {
            return $('>*', this.el).css({
              opacity: 1,
              'pointer-events': 'auto'
            });
          }
        };

        return Form;

      })(App.Views.ItemView);
    });
  });

}).call(this);
