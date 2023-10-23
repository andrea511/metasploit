(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.EmailTemplateView = (function(_super) {

      __extends(EmailTemplateView, _super);

      function EmailTemplateView() {
        return EmailTemplateView.__super__.constructor.apply(this, arguments);
      }

      EmailTemplateView.prototype.initialize = function() {
        this.loadingModal = $('<div class="loading">').dialog({
          modal: true,
          title: 'Submitting... ',
          autoOpen: false,
          closeOnEscape: false
        });
        return EmailTemplateView.__super__.initialize.apply(this, arguments);
      };

      EmailTemplateView.prototype.onLoad = function() {
        EmailTemplateView.__super__.onLoad.apply(this, arguments);
        $('select>option', this.el).each(function() {
          if ($(this).val() === '') {
            return $(this).removeAttr('value');
          }
        });
        $('select', this.el).select2(DEFAULT_SELECT2_OPTS);
        $('.clone-btn', this.el).click(window.renderCloneDialog);
        window.renderAttributeDropdown();
        return window.renderCodeMirror(240);
      };

      EmailTemplateView.prototype.renderHeader = function() {
        EmailTemplateView.__super__.renderHeader.apply(this, arguments);
        $('.header .page-circles', this.el).hide();
        return $('.header', this.el).addClass('no-box-shadow');
      };

      EmailTemplateView.prototype.actionButtons = function() {
        return [[['cancel link3 no-span', 'Cancel'], ['save primary', 'Save']]];
      };

      EmailTemplateView.prototype.save = function() {
        var $form,
          _this = this;
        $form = $('form', this.el);
        this.loadingModal.dialog('open');
        Placeholders.submitHandler($form[0]);
        $('textarea.to-code-mirror', $form).trigger('loadFromEditor');
        $form.trigger('syncWysiwyg');
        $.ajax({
          url: $form.attr('action'),
          type: $form.attr('method'),
          data: $form.serialize(),
          success: function(data) {
            _this.render();
            _this.close({
              confirm: false
            });
            return _this.loadingModal.dialog('close');
          },
          error: function(response) {
            $('.content-frame>.content', _this.el).html(response.responseText);
            _this.onLoad();
            return _this.loadingModal.dialog('close');
          }
        });
        return EmailTemplateView.__super__.save.apply(this, arguments);
      };

      return EmailTemplateView;

    })(FormView);
  });

}).call(this);
