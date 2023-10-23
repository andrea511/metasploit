(function() {
  var $, CLASSIC_DESCRIPTION, DYNAMIC_DESCRIPTION, DYNAMIC_STAGERS, ENCODER_IDX, FORM_URL, NUM_TABS, OUTPUT_IDX, POLL_WAIT, PREFERRED_ARCHES, UPSELL_URL, WIDTH, WINDOWS_ONLY_ENCODERS,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  $ = jQuery;

  WIDTH = 700;

  FORM_URL = '/wizards/payload_generator/form/';

  UPSELL_URL = "" + FORM_URL + "upsell";

  PREFERRED_ARCHES = ['x86', 'x64'];

  NUM_TABS = 3;

  ENCODER_IDX = 1;

  OUTPUT_IDX = 2;

  POLL_WAIT = 2000;

  DYNAMIC_STAGERS = ['reverse_tcp', 'reverse_http', 'reverse_https', 'bind_tcp'];

  DYNAMIC_DESCRIPTION = 'Generates a Windows executable that uses a dynamic stager ' + 'written entirely in randomized C code.';

  CLASSIC_DESCRIPTION = 'Builds a customized payload. (All platforms)';

  WINDOWS_ONLY_ENCODERS = ['generic/eicar'];

  this.PayloadGeneratorModal = (function(_super) {

    __extends(PayloadGeneratorModal, _super);

    function PayloadGeneratorModal() {
      this.useDynamicStagers = __bind(this.useDynamicStagers, this);

      this.payloadClass = __bind(this.payloadClass, this);

      this.formEl = __bind(this.formEl, this);

      this.inputEl = __bind(this.inputEl, this);

      this.serialize = __bind(this.serialize, this);

      this.renderUpsell = __bind(this.renderUpsell, this);

      this.formSubmittedSuccessfully = __bind(this.formSubmittedSuccessfully, this);

      this.transformErrorData = __bind(this.transformErrorData, this);

      this.mapErrorToSelector = __bind(this.mapErrorToSelector, this);

      this.formOverrides = __bind(this.formOverrides, this);

      this.renderEncoderOptions = __bind(this.renderEncoderOptions, this);

      this.renderPayloadOptions = __bind(this.renderPayloadOptions, this);

      this.setValue = __bind(this.setValue, this);

      this.setOptions = __bind(this.setOptions, this);

      this.removeNonWindowsEncoders = __bind(this.removeNonWindowsEncoders, this);

      this.updateForm = __bind(this.updateForm, this);

      this.payloadClassChanged = __bind(this.payloadClassChanged, this);

      this.formChanged = __bind(this.formChanged, this);

      this.encodingToggled = __bind(this.encodingToggled, this);

      this.renderForm = __bind(this.renderForm, this);

      this.getLicense = __bind(this.getLicense, this);

      this.validLicense = __bind(this.validLicense, this);

      this.layout = __bind(this.layout, this);

      this.render = __bind(this.render, this);
      return PayloadGeneratorModal.__super__.constructor.apply(this, arguments);
    }

    PayloadGeneratorModal.prototype._lastPayload = null;

    PayloadGeneratorModal.prototype._lastEncoder = null;

    PayloadGeneratorModal.prototype.initialize = function() {
      PayloadGeneratorModal.__super__.initialize.apply(this, arguments);
      this.setTitle('Payload Generator');
      this.setTabs([
        {
          name: 'Payload Options'
        }, {
          name: 'Encoding',
          checkbox: true
        }, {
          name: 'Output Options'
        }
      ]);
      this.setButtons([
        {
          name: 'Cancel',
          "class": 'close'
        }, {
          name: 'Generate',
          "class": 'btn primary'
        }
      ]);
      this._steps = _.map(this._tabs, function(tab) {
        return [tab.name, FORM_URL + _.str.underscored(tab.name)];
      });
      this._url = FORM_URL;
      this.genPayload = new GeneratedPayload();
      return PayloadCache.load(this.renderForm);
    };

    PayloadGeneratorModal.prototype.events = _.extend({
      'change form#payload_generator *': 'formChanged',
      'change input#tab_encoding': 'encodingToggled',
      'change li#payload_class input': 'payloadClassChanged'
    }, TabbedModalView.prototype.events);

    PayloadGeneratorModal.prototype.render = function() {
      var i, _i, _results;
      PayloadGeneratorModal.__super__.render.apply(this, arguments);
      this.tabAt(ENCODER_IDX).find('[type=checkbox]').prop('checked', true);
      _results = [];
      for (i = _i = 1; 1 <= NUM_TABS ? _i < NUM_TABS : _i > NUM_TABS; i = 1 <= NUM_TABS ? ++_i : --_i) {
        _results.push(this.tabAt(i).toggle(false));
      }
      return _results;
    };

    PayloadGeneratorModal.prototype.layout = function() {
      this.$modal.width(WIDTH);
      this.center();
      return this.$modal.addClass('payload-generator');
    };

    PayloadGeneratorModal.prototype.validLicense = function() {
      return "true";
    };

    PayloadGeneratorModal.prototype.getLicense = function() {
      return $('meta[name=msp-feed-edition]').attr('content');
    };

    PayloadGeneratorModal.prototype.renderForm = function() {
      var $hiddenPage, $li, template;
      template = JST['templates/wizards/payload_generator/form'];
      this.content().removeClass('loading tab-loading').html(template(this.genPayload));
      $li = this.content().find('li#payload_class').remove();
      $li.insertAfter($('h1:first', this.$modal));
      $hiddenPage = $('div.dynamic_payload_form');
      this._hiddenPage = $hiddenPage.find('div.page');
      this._hiddenPage.detach();
      $hiddenPage.remove();
      this.inputEl('badchars').ByteEntry();
      $('[name=authenticity_token]', this.$modal).val($('meta[name=csrf-token]').attr('content'));
      this.initTabs();
      if (this.getLicense() !== 'pro') {
        $li.find("input").prop('checked', false);
        $li.find("input[value='classic_payload']").prop('checked', true);
        this.payloadClassChanged();
      }
      return this.payloadClassChanged();
    };

    PayloadGeneratorModal.prototype.encodingToggled = function(e) {
      var $span, checked;
      checked = $(e.target).is(':checked');
      $span = this.pageAt(ENCODER_IDX).find('h3 span');
      this.genPayload.set('useEncoder', checked);
      if (!checked) {
        $span.removeClass('enabled').addClass('disabled').text('disabled');
        return this.pageAt(ENCODER_IDX).css({
          'pointer-events': 'none',
          opacity: 0.5
        });
      } else {
        $span.removeClass('disabled').addClass('enabled').text('enabled');
        return this.pageAt(ENCODER_IDX).css({
          'pointer-events': 'all',
          opacity: 1
        });
      }
    };

    PayloadGeneratorModal.prototype.formChanged = function() {
      var data, _ref, _ref1;
      if (this._updating) {
        return;
      }
      data = Backbone.Syphon.serialize(this.formEl()[0]);
      if (data != null) {
        if ((_ref = data.payload) != null) {
          delete _ref.options['payload'];
        }
      }
      this.genPayload.set((data != null ? (_ref1 = data.payload) != null ? _ref1.options : void 0 : void 0) || {});
      this.genPayload.set('useEncoder', $('#tab_encoding', this.$modal).is(':checked'));
      return this.updateForm();
    };

    PayloadGeneratorModal.prototype.payloadClassChanged = function(e) {
      var $tabs, removed,
        _this = this;
      this._updating = true;
      removed = this.formEl().find('div.page').detach();
      this._lastPayload = this._lastEncoder = null;
      if (this._upsell != null) {
        this._upsell.remove();
      }
      if (this._hiddenPage != null) {
        this.formEl().append(this._hiddenPage);
        this._hiddenPage = null;
      }
      $tabs = $('ul.tabs li', this.$modal).hide();
      _.times(this.formEl().find('div.page').length, function(i) {
        return $tabs.eq(i).show();
      });
      this._hiddenPage = removed;
      this.index(0);
      this.genPayload = new GeneratedPayload;
      if (this.useDynamicStagers()) {
        this.updateDescription(DYNAMIC_DESCRIPTION);
        if (this.getLicense() !== 'pro') {
          this.renderUpsell();
        }
      } else {
        this.updateDescription(CLASSIC_DESCRIPTION);
      }
      this._updating = false;
      return this.updateForm();
    };

    PayloadGeneratorModal.prototype.updateForm = function() {
      var $output, $primaryBtn, encodersPresent, i, numStagers, obj, stagersPresent, _i, _j,
        _this = this;
      obj = this.serialize();
      this._updating = true;
      if (this.genPayload.get('platform') !== 'Windows') {
        obj.encoders = this.removeNonWindowsEncoders(obj.encoders);
      }
      if (!_.contains(obj.arches, this.genPayload.get('arch'))) {
        this.genPayload.set('arch', obj.arches[0]);
        obj = this.serialize();
      }
      if (!_.contains(obj.stagers, this.genPayload.get('stager'))) {
        this.genPayload.set('stager', obj.stagers[0]);
      }
      if (!_.contains(obj.stages, this.genPayload.get('stage'))) {
        this.genPayload.set('stage', obj.stages[0]);
      }
      if (!_.contains(obj.singles, this.genPayload.get('single'))) {
        this.genPayload.set('single', obj.singles[0]);
      }
      if (!_.contains(obj.encoders, this.genPayload.get('encoder'))) {
        this.genPayload.set('encoder', obj.encoders[0]);
      }
      if (this.useDynamicStagers()) {
        obj.stagers = DYNAMIC_STAGERS;
        obj.arches = ["x86", "x64"];
      }
      this.setOptions('platform', obj.platforms);
      this.setOptions('arch', obj.arches);
      this.setOptions('stager', obj.stagers);
      this.setOptions('stage', obj.stages);
      this.setOptions('single', obj.singles);
      this.setOptions('encoder', obj.encoders);
      this.setOptions('format', obj.formats);
      numStagers = this.useDynamicStagers() ? 1 : NUM_TABS;
      for (i = _i = 0; 0 <= numStagers ? _i < numStagers : _i > numStagers; i = 0 <= numStagers ? ++_i : --_i) {
        this.tabAt(i).toggle(true);
      }
      encodersPresent = !_.isEmpty(obj.encoders);
      if (this.formEl().find('div.page').length > 1) {
        this.tabAt(ENCODER_IDX).toggle(encodersPresent);
      }
      $primaryBtn = $('a.btn.primary', this.$modal);
      if (this.useDynamicStagers() && this.getLicense() !== 'pro') {
        for (i = _j = 0; 0 <= NUM_TABS ? _j <= NUM_TABS : _j >= NUM_TABS; i = 0 <= NUM_TABS ? ++_j : --_j) {
          this.tabAt(i).toggle(false);
        }
        this.content().css({
          width: '100%',
          'margin-left': '10px',
          border: 'none'
        });
        $primaryBtn.addClass('_disabled unsupported');
      } else {
        this.content().css({
          width: '80%',
          'margin-left': '0',
          border: '2px solid #d6d6d6'
        });
        if ($primaryBtn.hasClass('unsupported')) {
          $primaryBtn.removeClass('_disabled unsupported');
        }
      }
      stagersPresent = obj.stagers.length > 0 && obj.stages.length > 0;
      if (!stagersPresent) {
        this.genPayload.set('useStager', false);
      }
      this.inputEl('useStager').parent().toggle(!!stagersPresent);
      this.inputEl('arch').parent().toggle(obj.arches.length > 1);
      if (stagersPresent) {
        this.inputEl('stager').parent().show();
        if (this.genPayload.get('useStager')) {
          this.inputEl('stager').css({
            'pointer-events': 'all',
            opacity: 1.0
          });
        } else {
          this.inputEl('stager').css({
            'pointer-events': 'none',
            opacity: 0.5
          });
        }
      } else {
        this.inputEl('stager').parent().hide();
      }
      this.inputEl('stage').parent().toggle(stagersPresent && this.genPayload.get('useStager'));
      this.inputEl('single').parent().toggle(!(stagersPresent && this.genPayload.get('useStager')));
      _.each(this.genPayload.attributes, function(val, key) {
        return _this.setValue(key, val);
      });
      this.renderPayloadOptions(obj);
      this.renderEncoderOptions(obj);
      if (this.useDynamicStagers()) {
        this.pageAt(0).find('li.exitfunc').hide();
      }
      this.inputEl('outputType').prop('checked', false).filter("[value=" + (this.genPayload.get('outputType')) + "]").prop('checked', true);
      $output = this.pageAt(OUTPUT_IDX);
      $output.find('li.exe,span.exe.span-front').toggle(this.genPayload.isOutputExe());
      $output.find('li.source').toggle(this.genPayload.isOutputBuffer());
      $output.find('li.not-raw').toggle(!this.genPayload.isOutputRaw());
      this.inputEl('keep').prop('checked', this.genPayload.get('keep'));
      this.resetErrors();
      this.renderFileInputs();
      this._updating = false;
      return $('ul.tabs li', this.$modal).find('.hasErrors').hide();
    };

    PayloadGeneratorModal.prototype.removeNonWindowsEncoders = function(encoders) {
      return _.reject(encoders, function(enc) {
        return _.contains(WINDOWS_ONLY_ENCODERS, enc);
      });
    };

    PayloadGeneratorModal.prototype.setOptions = function(inputName, options) {
      var $select,
        _this = this;
      if (_.isArray(options)) {
        options = _.object(options, options);
      }
      $select = this.inputEl(inputName).html('');
      return _.each(options, function(displayText, value) {
        return $select.append($('<option />', {
          value: value
        }).text(displayText));
      });
    };

    PayloadGeneratorModal.prototype.setValue = function(inputName, val) {
      var $input, option;
      $input = this.inputEl(inputName);
      if ($input.is(':text')) {
        return $input.val(val);
      } else if ($input.is('select')) {
        $input.find('option').prop('selected', false);
        option = _.find($input.find('option'), function(opt) {
          return opt.value === val;
        });
        if (option != null) {
          return $(option).prop('selected', true);
        }
      } else if ($input.is('[type=checkbox]')) {
        return $input.prop('checked', !!val);
      }
    };

    PayloadGeneratorModal.prototype.renderPayloadOptions = function(obj) {
      var advancedOptions, payload, template, _ref;
      payload = this.genPayload.findModule();
      if ((payload != null ? payload.refname : void 0) === ((_ref = this._lastPayload) != null ? _ref.refname : void 0)) {
        return;
      }
      if (payload == null) {
        return;
      }
      advancedOptions = payload.filteredOptions({
        advanced: true
      });
      template = JST['templates/wizards/payload_generator/datastore'];
      this.formEl().find('.payload-options .ajax').html(template({
        options: payload.filteredOptions({
          advanced: false
        }),
        optionsHashName: 'payload[options][payload_datastore]'
      }));
      this.formEl().find('.payload-options .ajax-advanced-options .render').html(template({
        options: advancedOptions,
        optionsHashName: 'payload[options][payload_datastore]'
      }));
      this.formEl().find('.payload-options .ajax-advanced-options').toggle(advancedOptions.length > 0);
      Forms.renderHelpLinks(this.el);
      $('#modals .inline-help').css({
        position: 'fixed'
      });
      return this._lastPayload = payload;
    };

    PayloadGeneratorModal.prototype.renderEncoderOptions = function(obj) {
      var advOpts, encoder, opts, template, _ref;
      encoder = this.genPayload.findEncoder();
      if (encoder == null) {
        return this.formEl().find('.encoder-options .ajax').html('');
      }
      if ((encoder != null ? encoder.refname : void 0) === ((_ref = this._lastEncoder) != null ? _ref.refname : void 0)) {
        return;
      }
      if (encoder == null) {
        return;
      }
      template = JST['templates/wizards/payload_generator/datastore'];
      opts = encoder.filteredOptions({
        advanced: false
      });
      advOpts = encoder.filteredOptions({
        advanced: true
      });
      this.formEl().find('.encoder-options .ajax').html(template({
        options: opts,
        optionsHashName: 'payload[options][encoder_datastore]'
      }));
      this.formEl().find('.encoder-options .ajax-advanced-options .render').html(template({
        options: advOpts,
        optionsHashName: 'payload[options][encoder_datastore]'
      }));
      this.formEl().find('.encoder-options.advanced').toggle(opts.length > 0);
      this.formEl().find('.encoder-options .ajax-advanced-options').toggle(advOpts.length > 0);
      Forms.renderHelpLinks(this.el);
      $('#modals .inline-help').css({
        position: 'fixed'
      });
      return this._lastEncoder = encoder;
    };

    PayloadGeneratorModal.prototype.formOverrides = function() {
      var overrides, _ref, _ref1;
      overrides = {
        'payload[options][payload]': ((_ref = this.genPayload.findModule()) != null ? _ref.refname : void 0) || '',
        'payload[options][encoder]': ((_ref1 = this.genPayload.findEncoder()) != null ? _ref1.refname : void 0) || '',
        'payload[payload_class]': this.payloadClass()
      };
      if (this.genPayload.isOutputRaw()) {
        _.extend(overrides, {
          'payload[options][format]': 'raw'
        });
      }
      if (!this.genPayload.get('useStager')) {
        _.extend(overrides, {
          'payload[options][stage]': ''
        });
      }
      return overrides;
    };

    PayloadGeneratorModal.prototype.mapErrorToSelector = function(attrName, modelName) {
      return attrName;
    };

    PayloadGeneratorModal.prototype.transformErrorData = function(errors) {
      var _base;
      errors.errors = {
        payload: errors.errors
      };
      if (errors.errors.payload.payload != null) {
        (_base = errors.errors.payload).options || (_base.options = {});
        errors.errors.payload["payload[options][single]"] = errors.errors.payload.payload;
        delete errors.errors.payload.payload;
      }
      return errors;
    };

    PayloadGeneratorModal.prototype.formSubmittedSuccessfully = function(data) {
      var done, poll,
        _this = this;
      if (!_.isEmpty(data != null ? data.errors : void 0)) {
        return this.handleSubmitError(data.errors);
      }
      done = false;
      poll = function() {
        return $.getJSON("" + FORM_URL + "poll?payload_id=" + data.id).done(function(data) {
          var close, modal;
          modal = _this;
          if (data.state === 'generating') {
            return _.delay(poll, POLL_WAIT);
          }
          if (data.state === 'failed') {
            _this._loaderDialog.dialog({
              title: 'Error Occurred',
              buttons: {
                Close: function() {
                  $(this).dialog('close');
                  return $(this).remove();
                }
              }
            });
            return _this._loaderDialog.removeClass('tab-loading loading').addClass('failed').append($('<p class="dialog-msg center">').text(data.generator_error));
          } else {
            close = function() {
              $(this).dialog('close');
              $(this).remove();
              return modal.close();
            };
            _this._loaderDialog.dialog({
              title: 'Payload generated',
              buttons: {
                Close: close,
                Download: function() {
                  var $f;
                  $f = $('<iframe />', {
                    src: "" + FORM_URL + "download?payload_id=" + data.id
                  });
                  $f.css({
                    display: 'none'
                  }).appendTo($('body'));
                  _.delay((function() {
                    return $f.remove();
                  }), 60 * 1000);
                  close.call(this);
                  return $('#modals').html('').addClass('empty');
                }
              }
            });
            _this._loaderDialog.removeClass('tab-loading loading failed').append($('<p class="dialog-msg center">').text("Filename: " + data.options.file_name)).append($('<p class="dialog-msg center">').text("Size: " + window.helpers.formatBytes(data.size)));
            return $('#modals .tabbed-modal').hide();
          }
        }).fail(function() {
          return _.delay(poll, POLL_WAIT);
        });
      };
      return _.delay(poll, POLL_WAIT);
    };

    PayloadGeneratorModal.prototype.renderUpsell = function() {
      var $upsell,
        _this = this;
      $upsell = $('.upsell', this.el).html('').addClass('tab-loading').css({
        height: 'auto',
        'min-height': '350px'
      });
      return $.get(UPSELL_URL, function(data) {
        return $upsell.html(data).removeClass('tab-loading');
      });
    };

    PayloadGeneratorModal.prototype.serialize = function(extraData) {
      if (extraData == null) {
        extraData = {};
      }
      return _.extend({}, this.genPayload.attributes, extraData, {
        platforms: PayloadCache.platforms().sort(),
        arches: PayloadCache.arches(this.genPayload.attributes).sort(),
        stagers: PayloadCache.stagerTypes(this.genPayload.attributes).sort(),
        stages: _.uniq(_.pluck(PayloadCache.stagers(this.genPayload.attributes), 'stageName')).sort(),
        singles: _.pluck(PayloadCache.singles(this.genPayload.attributes), 'refname').sort(),
        encoders: _.pluck(PayloadCache.encoders(this.genPayload.attributes), 'refname').sort(),
        formats: PayloadCache.formats({
          buffer: this.genPayload.isOutputBuffer()
        })
      });
    };

    PayloadGeneratorModal.prototype.inputEl = function(inputName) {
      return this.formEl().find("[name='payload[options][" + inputName + "]']");
    };

    PayloadGeneratorModal.prototype.formEl = function() {
      return this.$el.find('form#payload_generator');
    };

    PayloadGeneratorModal.prototype.payloadClass = function() {
      return this.$el.find('li#payload_class input:checked').val();
    };

    PayloadGeneratorModal.prototype.useDynamicStagers = function() {
      return this.payloadClass() === 'dynamic_stager';
    };

    return PayloadGeneratorModal;

  })(this.TabbedModalView);

}).call(this);
