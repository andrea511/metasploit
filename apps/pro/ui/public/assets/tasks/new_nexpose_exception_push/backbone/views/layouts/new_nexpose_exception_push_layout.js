(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'form_helpers', '/assets/templates/tasks/new_nexpose_exception_push/layouts/new_nexpose_exception_push-caf93634911d749c31fd0ac8a1ab72321665592912b36b7b7196c301fb0e50e3.js', '/assets/shared/backbone/layouts/tabs_layout-fb7b8503e9a0043ea7ec1c4160991a083b950fe41e26078183f66e3b886810ef.js', '/assets/tasks/new_nexpose_exception_push/backbone/views/layouts/exception_layout-bc94036e6d6e7ec3ab7b43e6941921517ae6872719f298ed9642776265659af1.js'], function($, FormHelpers, Template, TabsLayout, ExceptionLayout) {
    var NewNexposeExceptionPushLayout;
    return NewNexposeExceptionPushLayout = (function(_super) {

      __extends(NewNexposeExceptionPushLayout, _super);

      function NewNexposeExceptionPushLayout() {
        this._renderErrors = __bind(this._renderErrors, this);

        this.onShow = __bind(this.onShow, this);
        return NewNexposeExceptionPushLayout.__super__.constructor.apply(this, arguments);
      }

      NewNexposeExceptionPushLayout.prototype.template = HandlebarsTemplates['tasks/new_nexpose_exception_push/layouts/new_nexpose_exception_push'];

      NewNexposeExceptionPushLayout.prototype.initialize = function(opts) {
        return $.extend(this, opts);
      };

      NewNexposeExceptionPushLayout.prototype.events = {
        'click .push-exceptions a:not(.disabled)': '_submitForm',
        'change select[name="console"]': '_consoleChanged',
        'enablePushButton *': '_enablePushButton',
        'disablePushButton *': '_disablePushButton',
        'change input[name="auto_approve"]': '_autoApproveExceptions'
      };

      NewNexposeExceptionPushLayout.prototype.regions = {
        tabs: '.tabs'
      };

      NewNexposeExceptionPushLayout.prototype._init_nexpose_console_dropdown = function() {
        if (this.controller.MATCH_SET_ID != null) {
          return $('.hide-console-field, .console-field #console', this.el).css('visibility', 'hidden');
        }
      };

      NewNexposeExceptionPushLayout.prototype._disablePushButton = function() {
        return $('a.nexpose', this.el).addClass("disabled");
      };

      NewNexposeExceptionPushLayout.prototype._enablePushButton = function() {
        return $('a.nexpose', this.el).removeClass("disabled");
      };

      NewNexposeExceptionPushLayout.prototype.onShow = function() {
        var tab_layout, tab_model;
        tab_model = new Backbone.Model({
          tabs: [
            {
              name: "Vulnerability Exceptions",
              view: ExceptionLayout,
              controller: this.controller
            }
          ]
        });
        tab_layout = new TabsLayout({
          model: tab_model,
          maxHeight: 'none'
        });
        this.tabs.show(tab_layout);
        tab_layout.set_tab(tab_model.get('tabs')[0].name);
        return this._init_nexpose_console_dropdown();
      };

      NewNexposeExceptionPushLayout.prototype._autoApproveExceptions = function(e) {
        if ($(e.currentTarget).prop('checked')) {
          return $('.auto-approve', this.el).val("true");
        } else {
          return $('.auto-approve', this.el).val("false");
        }
      };

      NewNexposeExceptionPushLayout.prototype._consoleChanged = function() {
        this.tabs.reset();
        return this.onShow();
      };

      NewNexposeExceptionPushLayout.prototype._submitForm = function() {
        var form,
          _this = this;
        form = $('#exception-push-form', this.el).serialize();
        return $.ajax({
          type: "post",
          url: "/workspaces/" + WORKSPACE_ID + "/nexpose/result/exceptions.json",
          data: form,
          success: function(json) {
            $('.error').remove();
            return window.location.href = json.redirect_url;
          },
          error: function(e) {
            var json;
            json = $.parseJSON(e.responseText);
            return _this._renderErrors(json.errors);
          }
        });
      };

      NewNexposeExceptionPushLayout.prototype._renderErrors = function(errors) {
        var _this = this;
        $('.error').remove();
        return _.each(errors, function(v, k) {
          return _.each(v, function(v_2, k_2) {
            return _.each(v_2, function(v_3, k_3) {
              var $msg, name;
              name = "nexpose_result_exceptions[" + k + "][" + k_2 + "][" + k_3 + "]";
              $msg = $('<div />', {
                "class": 'error'
              }).text(v_3[0]);
              return $("[name='" + name + "']").addClass('invalid').after($msg);
            });
          });
        });
      };

      return NewNexposeExceptionPushLayout;

    })(Backbone.Marionette.LayoutView);
  });

}).call(this);
