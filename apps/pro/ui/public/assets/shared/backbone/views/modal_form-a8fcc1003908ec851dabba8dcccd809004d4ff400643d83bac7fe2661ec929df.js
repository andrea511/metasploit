(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/shared/item_views/modal_form-c4a8fb8b18a1c781ce2b9630e230497e17eb97e12e93fe6c96b1b11873f5271d.js', '/assets/templates/shared/item_views/inline_edit-7987b4e8932c6fcbbb38cb2c2d7f8478e435153869cd1648497bc95d260c4142.js', '/assets/shared/notification-center/backbone/event_aggregators/event_aggregator-aaf737212decc864bf321c2e97db0fff23791a0271c939abc3da67cee19fcd44.js'], function($, Template, EditTemplate, EventAggregator) {
    var ModalForm;
    return ModalForm = (function(_super) {

      __extends(ModalForm, _super);

      function ModalForm() {
        this._errorDiv = __bind(this._errorDiv, this);

        this._clearErrors = __bind(this._clearErrors, this);

        this._renderErrors = __bind(this._renderErrors, this);

        this._postForm = __bind(this._postForm, this);

        this._toggle = __bind(this._toggle, this);

        this._remove = __bind(this._remove, this);

        this._initInlineEdit = __bind(this._initInlineEdit, this);

        this.setLoading = __bind(this.setLoading, this);

        this.initEditInput = __bind(this.initEditInput, this);

        this.formLoadedSuccessfully = __bind(this.formLoadedSuccessfully, this);

        this.loadForm = __bind(this.loadForm, this);

        this.initialize = __bind(this.initialize, this);
        return ModalForm.__super__.constructor.apply(this, arguments);
      }

      ModalForm.prototype.template = HandlebarsTemplates['shared/item_views/modal_form'];

      ModalForm.prototype.initialize = function(opts) {
        if (opts == null) {
          opts = {};
        }
        this["class"] = '';
        this.options = opts;
        return $.extend(this, opts);
      };

      ModalForm.prototype.events = {
        'submit form': '_formSubmit'
      };

      ModalForm.prototype.loadForm = function(url) {
        return $.ajax({
          url: url,
          method: 'get',
          success: this.formLoadedSuccessfully
        });
      };

      ModalForm.prototype.formLoadedSuccessfully = function(html) {
        this.setLoading(false);
        $('.form-content', this.el).html(html);
        return this._initInlineEdit($('input.inline-edit', this.el));
      };

      ModalForm.prototype.initEditInput = function($input) {
        return this._renderTemplateHelper($input);
      };

      ModalForm.prototype.setLoading = function(loading) {
        $(this.el).toggleClass('tab-loading', loading);
        if (loading) {
          $('>*', this.el).css({
            opacity: 0.2,
            'pointer-events': 'none'
          });
        } else {
          $('>*', this.el).css({
            opacity: 1,
            'pointer-events': 'auto'
          });
        }
        $(':input', this.el).prop('disabled', loading);
        return this.$el.parents('.modal').find('.content ~ .modal-actions, .header a.close').toggleClass('disabled', loading);
      };

      ModalForm.prototype._initInlineEdit = function($inputs) {
        var vals,
          _this = this;
        vals = $.map($inputs, function(val, i) {
          return _this._renderTemplateHelper($($inputs[i]));
        });
        $(this.el).on('click', '.pencil', this._toggle);
        return $(this.el).on('click', '.garbage', this._remove);
      };

      ModalForm.prototype._remove = function(e) {
        var $container;
        $container = $(e.target).closest('.container');
        return $container.remove();
      };

      ModalForm.prototype._toggle = function(e) {
        var $container, $fieldText, $input;
        $container = $(e.target).closest('.container');
        $fieldText = $('.field-text', $container).toggle();
        $input = $('input', $container).toggle();
        return $fieldText.html($input.val());
      };

      ModalForm.prototype._renderTemplateHelper = function($input) {
        var $fragment, context, template;
        template = HandlebarsTemplates['shared/item_views/inline_edit'];
        context = {
          ref: $input.val()
        };
        $fragment = $(template(context)).insertAfter($input);
        $input.prependTo($('.input-container', $fragment));
        if ($input.val() !== "") {
          return $input.hide();
        } else {
          return $('.field-text', $input.closest('.container')).hide();
        }
      };

      ModalForm.prototype._postForm = function() {
        var data;
        data = $('form', this.el).serialize();
        switch (this.options.action) {
          case "new":
            return $.ajax({
              url: this.URL,
              type: 'POST',
              data: data
            });
          case "edit":
            return $.ajax({
              url: "" + this.URL + this.options.id + ".json",
              type: 'PUT',
              data: data
            });
        }
      };

      ModalForm.prototype._renderErrors = function(errors) {
        var _this = this;
        return _.each(errors, function(v, k) {
          var $input;
          $input = $("[name*='[" + k + "]']", _this.el);
          $input.parents('li').first().addClass('error');
          return $input.parent().append(_this._errorDiv(v));
        });
      };

      ModalForm.prototype._clearErrors = function() {
        $('.error', this.el).removeClass('error');
        return $('p.inline-error', this.el).remove();
      };

      ModalForm.prototype._errorDiv = function(msg) {
        return $('<p />', {
          "class": 'inline-error'
        }).text(msg);
      };

      ModalForm.prototype._formSubmit = function(e) {
        e.preventDefault();
        this._postForm();
        EventAggregator.trigger('redrawTable');
        return this.$el.trigger('destroy');
      };

      return ModalForm;

    })(Backbone.Marionette.LayoutView);
  });

}).call(this);
