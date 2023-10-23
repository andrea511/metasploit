(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.WebTemplateView = (function(_super) {

      __extends(WebTemplateView, _super);

      function WebTemplateView() {
        return WebTemplateView.__super__.constructor.apply(this, arguments);
      }

      WebTemplateView.prototype.initialize = function() {
        this.loadingModal = $('<div class="loading">').dialog({
          modal: true,
          title: 'Submitting...',
          autoOpen: false,
          closeOnEscape: false
        });
        return WebTemplateView.__super__.initialize.apply(this, arguments);
      };

      WebTemplateView.prototype.onLoad = function() {
        WebTemplateView.__super__.onLoad.apply(this, arguments);
        $('select>option', this.el).each(function() {
          if ($(this).val() === '') {
            return $(this).removeAttr('value');
          }
        });
        $('select', this.el).select2(DEFAULT_SELECT2_OPTS);
        window.renderAttributeDropdown();
        window.renderCodeMirror(220);
        return $('a.clone-btn', this.el).click(window.renderCloneDialog);
      };

      WebTemplateView.prototype.actionButtons = function() {
        return [[['cancel link3 no-span', 'Cancel'], ['save primary', 'Save']]];
      };

      WebTemplateView.prototype.save = function() {
        var $form,
          _this = this;
        this.loadingModal.dialog('open');
        $form = $('form', this.el);
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
        return WebTemplateView.__super__.save.apply(this, arguments);
      };

      return WebTemplateView;

    })(FormView);
  });

}).call(this);
