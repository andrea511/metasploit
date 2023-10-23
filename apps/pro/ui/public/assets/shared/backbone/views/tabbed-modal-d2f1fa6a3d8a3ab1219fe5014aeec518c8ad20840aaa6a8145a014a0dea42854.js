(function() {
  var $,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  $ = jQuery;

  this.INFINITY = '\u221E';

  this.INFINITY_DISCRETE = 99999999999;

  this.TabbedModalView = (function(_super) {

    __extends(TabbedModalView, _super);

    function TabbedModalView() {
      this.validLicense = __bind(this.validLicense, this);

      this.pageAt = __bind(this.pageAt, this);

      this.tabAt = __bind(this.tabAt, this);

      this.tabCheckboxClicked = __bind(this.tabCheckboxClicked, this);

      this.tabClicked = __bind(this.tabClicked, this);

      this.someInputChanged = __bind(this.someInputChanged, this);

      this.resetErrorsOnTab = __bind(this.resetErrorsOnTab, this);

      this.resetErrors = __bind(this.resetErrors, this);

      this.handleErrors = __bind(this.handleErrors, this);

      this.mapErrorToSelector = __bind(this.mapErrorToSelector, this);

      this._index = __bind(this._index, this);

      this.index = __bind(this.index, this);

      this.validate = __bind(this.validate, this);

      this.stubCustomConfirm = __bind(this.stubCustomConfirm, this);

      this.escKeyHandler = __bind(this.escKeyHandler, this);

      this.close = __bind(this.close, this);

      this.open = __bind(this.open, this);

      this.styleDisabledOverlay = __bind(this.styleDisabledOverlay, this);

      this.center = __bind(this.center, this);

      this.layout = __bind(this.layout, this);

      this.updateDescription = __bind(this.updateDescription, this);

      this.setMaxWidth = __bind(this.setMaxWidth, this);

      this.setTitle = __bind(this.setTitle, this);

      this.setDescription = __bind(this.setDescription, this);

      this.setButtons = __bind(this.setButtons, this);

      this.setTabs = __bind(this.setTabs, this);

      this.toggleAdvanced = __bind(this.toggleAdvanced, this);

      this.applyFormOverrides = __bind(this.applyFormOverrides, this);

      this.handleSubmitError = __bind(this.handleSubmitError, this);

      this.submitButtonClicked = __bind(this.submitButtonClicked, this);

      this.hideLoadingDialog = __bind(this.hideLoadingDialog, this);

      this.showLoadingDialog = __bind(this.showLoadingDialog, this);

      this.updateSliderValue = __bind(this.updateSliderValue, this);

      this.renderSliders = __bind(this.renderSliders, this);

      this.formLoadedSuccessfully = __bind(this.formLoadedSuccessfully, this);

      this.renderFileInputs = __bind(this.renderFileInputs, this);

      this.initTabs = __bind(this.initTabs, this);

      this.formLoadedSuccessfully = __bind(this.formLoadedSuccessfully, this);

      this.passwordDisplayChanged = __bind(this.passwordDisplayChanged, this);

      this.childCheckboxChanged = __bind(this.childCheckboxChanged, this);

      this.selectAllInParentDiv = __bind(this.selectAllInParentDiv, this);
      return TabbedModalView.__super__.constructor.apply(this, arguments);
    }

    TabbedModalView.prototype._tabIdx = -1;

    TabbedModalView.prototype._opened = false;

    TabbedModalView.prototype._steps = [];

    TabbedModalView.prototype._edited = false;

    TabbedModalView.prototype._modelsToTabs = {};

    TabbedModalView.prototype.events = {
      'click a.advanced': 'toggleAdvanced',
      'click a.close': 'close',
      'click ul.tabs>li': 'tabClicked',
      'click ul.tabs input[type=checkbox], ul.tabs label': 'tabCheckboxClicked',
      'change select': 'someInputChanged',
      'change input, textarea': 'someInputChanged',
      'keydown input, textarea': 'someInputChanged',
      'click .tabbed-modal .modal-actions .btn.primary': 'submitButtonClicked',
      'change label.plaintext input': 'passwordDisplayChanged',
      'change input.select-all-in-parent-div[type=checkbox]': 'selectAllInParentDiv',
      'change .selectable-by-parent input[type=checkbox]': 'childCheckboxChanged'
    };

    TabbedModalView.prototype.initialize = function(opts) {
      this.setMaxWidth(1000);
      this.origConfirm || (this.origConfirm = window.origConfirm || window.confirm);
      _.extend(this, opts);
      if (!opts.appendToEl) {
        return this.$el.appendTo($('body'));
      }
    };

    TabbedModalView.prototype.selectAllInParentDiv = function(e) {
      var checked;
      checked = $(e.currentTarget).is(':checked');
      return $(e.currentTarget).parents('div').first().find('input[type=checkbox]').prop('checked', checked);
    };

    TabbedModalView.prototype.childCheckboxChanged = function(e) {
      var $children, $notChecked;
      $children = $(e.currentTarget).parents('div.selectable-by-parent');
      $notChecked = $children.find('input[type=checkbox]').not(':checked');
      return $children.parent().find('h3 input.select-all-in-parent-div').prop('checked', $notChecked.length === 0);
    };

    TabbedModalView.prototype.loadForm = function(url) {
      var _this = this;
      if (this.cachedNode != null) {
        return _.defer(this.formLoadedSuccessfully, this.cachedNode);
      } else {
        return $.ajax({
          url: url,
          method: 'get',
          success: this.formLoadedSuccessfully,
          data: {
            task_config_id: this.taskConfigId
          },
          error: function() {
            _this.content().removeClass('loading').addClass('error').text("Unable to reach Metasploit Pro. Please ensure you" + " are connected and the Metasploit Pro service is running.");
            return _.delay((function() {
              return _this.content().is(':visible') && _this.loadForm(url);
            }), 5000);
          }
        });
      }
    };

    TabbedModalView.prototype.passwordDisplayChanged = function(e) {
      var $newInput, $passInput;
      $passInput = $(e.currentTarget).parents().filter('label.plaintext').first().prev().find('input');
      if ($(e.currentTarget).attr('checked')) {
        $newInput = $("<input type='text'>");
        $newInput.attr('name', $passInput.attr('name'));
        $newInput.val($passInput.val());
        return $passInput.replaceWith($newInput);
      } else {
        $newInput = $("<input type='password'>");
        $newInput.attr('name', $passInput.attr('name'));
        $newInput.val($passInput.val());
        return $passInput.replaceWith($newInput);
      }
    };

    TabbedModalView.prototype.formLoadedSuccessfully = function(html) {
      this.content().removeClass('loading tab-loading').html(html);
      _.each(this.tabs(), function(t) {
        return $(t).removeClass('ui-disabled');
      });
      return this._steps = $.parseJSON($('meta[name=steps]', this.$modal).attr('content') || 'null');
    };

    TabbedModalView.prototype.initTabs = function() {
      var _this = this;
      _.each(this.tabs(), function(t) {
        return $(t).removeClass('ui-disabled');
      });
      $('div.content form .page', this.$modal).each(function() {
        return $(this).append($('<div>').addClass('page-overlay'));
      });
      Forms.renderHelpLinks(this.el);
      $('#modals .inline-help').css({
        position: 'fixed'
      });
      this.renderFileInputs();
      this.index(0);
      _.defer(this.layout);
      _.defer(function() {
        return $('form :text:visible:first', _this.content()).focus();
      });
      return this.renderSliders();
    };

    TabbedModalView.prototype.renderFileInputs = function() {
      if (this.cachedNode) {
        $('input:file', this.$modal).each(function() {
          return $(this).on('change', function(e) {
            var $p, path;
            $p = $('p', $(e.target).parent());
            path = $(this).val().replace(/.*(\\|\/)/g, '');
            if (_.isEmpty(path)) {
              return $p.html('&nbsp;');
            } else {
              return $p.text(path);
            }
          });
        });
        return;
      }
      return $('input:file', this.$modal).each(function() {
        var $label, $p, $span, origText;
        if ($(this).data('rendered')) {
          return;
        }
        $label = $(this).prev();
        origText = $label.text() || 'file';
        $(this).attr('size', '50').css({
          overflow: 'hidden'
        });
        $p = $('<p>').text('No file selected');
        $span = $('<span>').text("Choose " + origText + "...");
        $label.html('').append($p).append($span);
        $(this).data('rendered', '1');
        return $(this).change(function() {
          var path;
          path = $(this).val().replace(/.*(\\|\/)/g, '');
          if (_.isEmpty(path)) {
            return $p.html('&nbsp;');
          } else {
            return $p.text(path);
          }
        });
      });
    };

    TabbedModalView.prototype.formLoadedSuccessfully = function(html) {
      if (html != null) {
        this.content().removeClass('loading tab-loading').html(html);
      }
      this._steps = $.parseJSON($('meta[name=steps]', this.$modal).attr('content') || 'null');
      return this.initTabs();
    };

    TabbedModalView.prototype.renderSliders = function() {
      var update,
        _this = this;
      update = this.updateSliderValue;
      return $('form li.slider', this.$modal).each(function(index, elem) {
        var $field, $slider, inc, infinity, isBytes, max, min, onChange;
        $field = $(':input', elem).first();
        if ($field.data('slidered')) {
          return;
        }
        $(elem).data('slidered', true);
        min = parseInt($field.attr('data-min')) || 0;
        max = parseInt($field.attr('data-max')) || 0;
        inc = parseInt($field.attr('data-inc')) || 0;
        isBytes = $field.attr('data-bytes') || false;
        infinity = !!$field.attr('data-infinity');
        onChange = function(e, ui) {
          var $input;
          $input = $(':input', elem);
          if ($input.length === 0) {
            $input = $(elem).siblings(':input');
          }
          update($input, ui.value);
          if (infinity && max === ui.value) {
            return $input.val(INFINITY);
          }
        };
        $slider = $("<div />").appendTo(elem).slider({
          min: parseInt(min),
          max: parseInt(max),
          value: _this._parseInputField($field),
          step: inc,
          slide: onChange,
          change: onChange
        });
        $field.focusout(function() {
          var $el, newVal;
          $el = $(elem).find('input').addBack().filter('input').first();
          newVal = isBytes ? helpers.parseBytes($el.val()) : parseInt($el.val());
          try {
            if (parseInt($slider.slider('value')) !== newVal) {
              return $slider.slider('value', newVal);
            }
          } catch (e) {
            return console.log("exception caught");
          }
        });
        return update($field, $field.val());
      });
    };

    TabbedModalView.prototype.updateSliderValue = function($input, value) {
      return $input.val(value);
    };

    TabbedModalView.prototype.showLoadingDialog = function() {
      return helpers.showLoadingDialog.call(this);
    };

    TabbedModalView.prototype.hideLoadingDialog = function() {
      return helpers.hideLoadingDialog.call(this);
    };

    TabbedModalView.prototype.submitButtonClicked = function(e) {
      var $form, $page;
      e.preventDefault();
      if ($(e.currentTarget).hasClass('disabled')) {
        return;
      }
      this.resetErrors();
      $form = $('form', this.$modal).first();
      if (this.submitUrl != null) {
        $form.attr('action', this.submitUrl());
      }
      $('.hasErrors', this.$modal).hide();
      $page = this.pageAt(this._tabIdx);
      this.showLoadingDialog();
      return this.submitFormAjax($form, {
        url: this._url || $form.attr('action'),
        method: 'POST',
        error: this.handleSubmitError,
        success: this.formSubmittedSuccessfully
      });
    };

    TabbedModalView.prototype.transformFormData = function(data) {
      return data;
    };

    TabbedModalView.prototype.transformErrorData = function(data) {
      return data;
    };

    TabbedModalView.prototype.handleSubmitError = function(e) {
      var $closeBtn, $errTab, $page, $primaryBtn, $selTab;
      this.hideLoadingDialog();
      $primaryBtn = $('a.btn.primary', this.$modal);
      $closeBtn = $('.modal-actions a.close', this.$modal);
      $page = this.pageAt(this._tabIdx);
      $page.removeClass('page-loading');
      $primaryBtn.addClass('disabled');
      $closeBtn.removeClass('ui-disabled');
      this.handleErrors.apply(this, arguments);
      $errTab = $('ul.tabs>li span.hasErrors:visible', this.$modal).parents('li').first();
      $selTab = $('ul.tabs>li.selected', this.$modal);
      if ($errTab.size() > 0 && $errTab[0] !== $selTab[0]) {
        return this.index($errTab.index(), false);
      }
    };

    TabbedModalView.prototype.formSubmittedSuccessfully = function(data) {
      return window.location = data.path;
    };

    TabbedModalView.prototype.applyFormOverrides = function(data, $node) {
      var overrides;
      if ($node == null) {
        $node = null;
      }
      if (!(this.formOverrides != null)) {
        return data;
      } else {
        overrides = this.formOverrides($node);
        return $(_.map(data, function(input) {
          var matching_key;
          matching_key = _.find(_.keys(overrides), function(key) {
            return input.name.indexOf(key) > -1;
          });
          if (matching_key) {
            return $('<input />', {
              name: input.name,
              type: 'hidden',
              value: overrides[matching_key]
            })[0];
          } else {
            return input;
          }
        }));
      }
    };

    TabbedModalView.prototype.sendAjax = function($form, $node) {
      var data;
      if ($node == null) {
        $node = null;
      }
      data = $(':input', $form).not(':file');
      data = this.transformFormData(data);
      return data = this.applyFormOverrides(data, $node);
    };

    TabbedModalView.prototype.submitFormAjax = function($form, opts) {
      var data,
        _this = this;
      if (opts == null) {
        opts = {};
      }
      $('input[name=_method]', $form).not(':first').remove();
      $('input[name=_method]', $form).val(opts.method || 'PUT');
      $('input[name=no_files]', $form).val((opts.noFiles && '1') || '');
      data = this.sendAjax();
      return $.ajax({
        url: opts['url'] || this._steps[this._tabIdx][1],
        type: 'POST',
        data: opts['noFiles'] ? data.serialize() : data.serializeArray(),
        processData: !!opts['noFiles'],
        iframe: !opts['noFiles'],
        files: opts['noFiles'] ? $() : $(':file', $form),
        dataType: 'json',
        complete: function(resp) {
          var $closeBtn, $primaryBtn, _ref, _ref1;
          try {
            data = $.parseJSON(resp.responseText);
          } catch (e) {
            alert('Error processing response from server. Please ensure Metasploit Pro is running.');
            _this.hideLoadingDialog();
            $primaryBtn = $('a.btn.primary', _this.$modal);
            $closeBtn = $('.modal-actions a.close', _this.$modal);
            $primaryBtn.removeClass('disabled');
            $closeBtn.removeClass('ui-disabled');
            return;
          }
          if (!data || !data['success']) {
            return opts != null ? (_ref = opts.error) != null ? _ref.call(_this, data) : void 0 : void 0;
          } else {
            return opts != null ? (_ref1 = opts.success) != null ? _ref1.call(_this, data) : void 0 : void 0;
          }
        }
      });
    };

    TabbedModalView.prototype.toggleAdvanced = function(e) {
      var $toShow;
      e.preventDefault();
      $(e.currentTarget).toggleClass('not_advanced');
      $toShow = $('~div.advanced', e.currentTarget);
      if ($toShow.size() === 0) {
        $toShow = $($(e.currentTarget).attr('data-toggle-selector'), this.$modal);
      }
      return $toShow.toggle();
    };

    TabbedModalView.prototype.setTabs = function(_tabs) {
      this._tabs = _tabs;
      return _.each(this._tabs, function(tab) {
        tab['class'] || (tab['class'] = '');
        return tab['checkbox'] || (tab['checkbox'] = false);
      });
    };

    TabbedModalView.prototype.setButtons = function(_btns) {
      this._btns = _btns;
      return _.each(this._btns, function(btn) {
        return btn['class'] || (btn['class'] = '');
      });
    };

    TabbedModalView.prototype.setDescription = function(description) {
      this.description = description;
    };

    TabbedModalView.prototype.setTitle = function(title) {
      this.title = title;
    };

    TabbedModalView.prototype.setMaxWidth = function(maxWidth) {
      this.maxWidth = maxWidth;
    };

    TabbedModalView.prototype.updateDescription = function(description) {
      this.description = description;
      return this.$modal.find('>div.padding>p').text(this.description);
    };

    TabbedModalView.prototype.layout = function() {
      if (this.$modal.width() > this.maxWidth) {
        this.$modal.width(this.maxWidth);
      }
      return this.center();
    };

    TabbedModalView.prototype.center = function() {
      var modalWidth, screenWidth;
      modalWidth = this.$modal.width();
      screenWidth = $(window).width();
      this.$modal.css('left', parseInt(($(window).width() - this.$modal.width()) / 2) + 'px');
      this.$modal.css('top', parseInt(($(window).height() - this.$modal.height()) / 2) + 'px');
      return $('ul.tabs>li:first-child', this.el).addClass('first-child');
    };

    TabbedModalView.prototype.styleDisabledOverlay = function() {
      var disabled_overlay;
      $('.tabbed-modal', this.$el).css({
        maxWidth: 800
      });
      $('.tabbed-modal', this.$el).css("width", '800');
      disabled_overlay = $('.body-disabled-overlay', this.$el);
      disabled_overlay.removeClass('invisible');
      return disabled_overlay.addClass('disabled-overlay-modal');
    };

    TabbedModalView.prototype.template = _.template($('#tabbed-modal').html());

    TabbedModalView.prototype.open = function() {
      this.render();
      this._opened = true;
      this.escEnabled = true;
      this.stubCustomConfirm();
      $('#modals').removeClass('empty');
      if (this.appendToEl == null) {
        $('body').css({
          overflow: 'hidden'
        }).height($(window).height());
      }
      this.$el.find('.tabbed-modal').addClass(_.str.underscored(this.constructor.name));
      $(window).unbind('resize.tabbedModal', this.layout);
      $(window).unbind('keyup.tabbedModal', this.escKeyHandler);
      $(window).bind('resize.tabbedModal', this.layout);
      $(window).bind('keyup.tabbedModal', this.escKeyHandler);
      return this;
    };

    TabbedModalView.prototype.close = function(e) {
      $('#modals').addClass('empty');
      if (e && e.preventDefault) {
        e.preventDefault();
      }
      this.$el.html('');
      this._opened = false;
      this.escEnabled = false;
      $('body').css({
        overflow: 'auto'
      }).css({
        height: 'auto',
        overflow: 'inherit'
      });
      $(window).unbind('resize.tabbedModal', this.layout);
      $(window).unbind('keyup.tabbedModal', this.escKeyHandler);
      window.confirm = this.origConfirm;
      return this.undelegateEvents();
    };

    TabbedModalView.prototype.escKeyHandler = function(e) {
      var _ref, _ref1;
      if (this.appendToEl) {
        return;
      }
      if (((_ref = String.fromCharCode(e.keyCode)) != null ? (_ref1 = _ref.match(/[\w]+/)) != null ? _ref1.length : void 0 : void 0) > 0) {
        this._edited = true;
      }
      if (e.keyCode === 27 && this.escEnabled) {
        if (this._edited) {
          if (window.confirm('Are you sure you want to close this panel? Any text input will be lost.')) {
            return this.close();
          }
        } else {
          return this.close();
        }
      }
    };

    TabbedModalView.prototype.stubCustomConfirm = function() {
      var _this = this;
      return window.confirm = function() {
        if (_this._opened) {
          _this.escEnabled = false;
          _.delay((function() {
            return _this.escEnabled = true;
          }), 300);
          return _this.origConfirm.apply(window, arguments);
        } else {
          return _this.origConfirm.apply(window, arguments);
        }
      };
    };

    TabbedModalView.prototype.validate = function(opts) {
      var $allTabs, $form, $li, $page, success,
        _this = this;
      if (opts == null) {
        opts = {
          noFiles: true
        };
      }
      $form = $('form', this.el);
      $allTabs = $('form>div.page', this.$el);
      this._somethingHasChanged = false;
      $li = $('ul.tabs>li', this.$modal).eq(this._tabIdx).addClass('tab-loading');
      $page = $('div.content form .page').eq(this._tabIdx).addClass('page-loading');
      $page.find('p.error-desc').remove();
      success = function() {
        $li.removeClass('tab-loading ui-disabled');
        $page.removeClass('page-loading');
        _this.errors = null;
        $(document).trigger("tabbedModalValidated", _this);
        if (!($('.hasErrors:visible', _this.$modal).length > 0)) {
          return $('a.btn.primary', _this.$modal).removeClass('disabled');
        }
      };
      return this.submitFormAjax($form, {
        noFiles: opts.noFiles,
        success: success,
        error: function(data) {
          $('p.inline-error', _this.el).remove();
          $li.removeClass('tab-loading ui-disabled');
          $page.removeClass('page-loading');
          $('a.btn.primary', _this.$modal).addClass('disabled');
          _this.handleErrors.call(_this, data);
          return $(document).trigger("tabbedModalValidated", _this);
        }
      });
    };

    TabbedModalView.prototype.index = function(idx, validate) {
      var $allTabs, $currTab, $form, $li, $page, oldTabIdx, success,
        _this = this;
      if (validate == null) {
        validate = true;
      }
      $form = $('form', this.$el);
      $allTabs = $('form>div.page', this.$el);
      $currTab = $allTabs.eq(idx);
      this._somethingHasChanged = false;
      if (!(this._tabIdx < 0 || idx === this._tabIdx || !validate)) {
        oldTabIdx = this._tabIdx;
        this.resetErrorsOnTab(oldTabIdx);
        $li = $('ul.tabs>li', this.$modal).eq(this._tabIdx).addClass('tab-loading');
        $page = $('div.content form .page').eq(this._tabIdx).addClass('page-loading');
        $page.find('p.error-desc').remove();
        success = function() {
          $li.removeClass('tab-loading ui-disabled');
          $page.removeClass('page-loading');
          _this.errors = null;
          $(document).trigger("tabbedModalValidated", _this);
          if (!($('.hasErrors:visible', _this.$modal).length > 0)) {
            return $('a.btn.primary', _this.$modal).removeClass('disabled');
          }
        };
        this.submitFormAjax($form, {
          noFiles: true,
          success: success,
          error: function(data) {
            $li.removeClass('tab-loading ui-disabled');
            $page.removeClass('page-loading');
            $('a.btn.primary', _this.$modal).addClass('disabled');
            _this.handleErrors.call(_this, data, oldTabIdx);
            return $(document).trigger("tabbedModalValidated", _this);
          }
        });
      }
      $allTabs.hide().eq(idx).show();
      return this._index(idx);
    };

    TabbedModalView.prototype._index = function(idx) {
      var $li, $ul;
      if (typeof idx === 'undefined') {
        return this._tabIdx;
      }
      if (idx === this._tabIdx || idx < 0 || idx >= this._tabs.length) {
        return this._tabIdx;
      }
      $ul = $('ul.tabs', this.el);
      $li = $('li', $ul).removeClass('selected').eq(idx).addClass('selected');
      $('div.content', this.el).toggleClass('top-left-square', idx === 0);
      this._tabIdx = idx;
      return this._tabIdx;
    };

    TabbedModalView.prototype.mapErrorToSelector = function(attrName, modelName) {
      return "" + modelName + "[" + attrName + "]";
    };

    TabbedModalView.prototype.handleErrors = function(errorsHash) {
      var alreadyClearedTabs,
        _this = this;
      errorsHash = this.transformErrorData(errorsHash);
      $('.hasError', this.$modal).hide();
      alreadyClearedTabs = {};
      _.each(errorsHash.errors, function(modelErrors, modelName) {
        var $page, $tab, tabIdx;
        tabIdx = _this._modelsToTabs[modelName];
        if (typeof modelErrors === 'string' && $.trim(modelErrors).length > 0) {
          $tab = _this.tabAt(tabIdx);
          $tab.find('.hasErrors').show();
          $page = _this.pageAt(tabIdx);
          if (!alreadyClearedTabs["" + tabIdx]) {
            $page.find('p.inline-error').remove();
            $page.find('p.error-desc').remove();
            alreadyClearedTabs["" + tabIdx] = true;
          }
          return $page.prepend($('<p>').addClass('error-desc').text(modelErrors));
        } else if (typeof modelErrors === 'object' && _.keys(modelErrors).length > 0) {
          if (_this._modelsToModels) {
            modelName = _this._modelsToModels[modelName];
          }
          return _.each(modelErrors, function(attrErrors, attrName) {
            var $input, $li, idx, inputName;
            inputName = _this.mapErrorToSelector(attrName, modelName);
            $input = $("[name='" + inputName + "']", _this.modal);
            $page = $input.parents('div.page').first();
            if (!alreadyClearedTabs["" + tabIdx]) {
              $page.find('p.inline-error').remove();
              $page.find('p.error-desc').remove();
              alreadyClearedTabs["" + tabIdx] = true;
            }
            idx = $page.index('div.page');
            if (idx > -1) {
              _this.tabAt(idx).find('.hasErrors').show();
              $li = $input.parents('li').first().addClass('error');
              $li.find('.inline-error').remove();
              return _.each(attrErrors, function(errorMsg) {
                return $("<p>", {
                  "class": 'inline-error'
                }).appendTo($li).text(errorMsg);
              });
            }
          });
        }
      });
      return null;
    };

    TabbedModalView.prototype.resetErrors = function(scope) {
      if (scope == null) {
        scope = this.$modal;
      }
      $('p.inline-error', scope).remove();
      return $('li.error', scope).removeClass('error');
    };

    TabbedModalView.prototype.resetErrorsOnTab = function(tabIdx) {
      if (tabIdx == null) {
        tabIdx = this._tabIdx;
      }
      this.resetErrors($('form:first>div.page', this.$el).eq(tabIdx));
      return this.tabAt(tabIdx).find('.hasErrors').hide();
    };

    TabbedModalView.prototype.someInputChanged = function(e) {
      $('a.btn.primary', this.$modal).removeClass('disabled');
      return this._somethingHasChanged = true;
    };

    TabbedModalView.prototype.tabClicked = function(e) {
      var $li;
      if ($(e.currentTarget).hasClass('ui-disabled')) {
        return false;
      }
      $li = $(e.currentTarget);
      return this.index($li.index());
    };

    TabbedModalView.prototype.tabCheckboxClicked = function(e) {
      var $li;
      $li = $(e.currentTarget).parents('li').first();
      if (!($li.hasClass('selected') || $(e.target).is('input'))) {
        return e.preventDefault();
      }
    };

    TabbedModalView.prototype.tabAt = function(idx) {
      return $('ul.tabs li', this.$modal).eq(idx);
    };

    TabbedModalView.prototype.pageAt = function(idx) {
      return $('>form>div.page', this.content()).eq(idx);
    };

    TabbedModalView.prototype.render = function() {
      TabbedModalView.__super__.render.apply(this, arguments);
      this.license = this.validLicense();
      this.$el.html(this.template(this));
      this.$modal = $('.tabbed-modal', this.$el);
      if (this._tabIdx < 0) {
        this.index(0);
      }
      if (this.license === 'false') {
        this.styleDisabledOverlay();
      }
      return this.layout();
    };

    TabbedModalView.prototype.validLicense = function() {
      return $('meta[name=license]').attr("content");
    };

    TabbedModalView.prototype.tabs = function() {
      return $('ul.tabs>li', this.$modal);
    };

    TabbedModalView.prototype.content = function() {
      return $('.padding>.content', this.$modal);
    };

    TabbedModalView.prototype._parseInputField = function($field) {
      if ($field.val().match(/(B|KB|MB|GB|TB)/g) != null) {
        return helpers.parseBytes($field.val());
      } else {
        return parseInt($field.val());
      }
    };

    return TabbedModalView;

  })(Backbone.View);

}).call(this);
