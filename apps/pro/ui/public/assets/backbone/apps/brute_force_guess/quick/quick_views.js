(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['base_layout', 'base_view', 'base_itemview', 'apps/brute_force_guess/quick/templates/quick_layout', 'apps/brute_force_guess/quick/templates/mutation_view', 'apps/brute_force_guess/quick/templates/targets_view', 'apps/brute_force_guess/quick/templates/creds_view', 'apps/brute_force_guess/quick/templates/options_view', 'apps/brute_force_guess/quick/templates/confirmation_view', 'apps/brute_force_guess/quick/templates/cred_limit_view', 'lib/concerns/views/text_area_limit'], function() {
    return this.Pro.module('BruteForceGuessApp.Quick', function(Quick, App, Backbone, Marionette, $, _) {
      var CHUNK_SIZE;
      CHUNK_SIZE = 20000;
      Quick.Layout = (function(_super) {

        __extends(Layout, _super);

        function Layout() {
          return Layout.__super__.constructor.apply(this, arguments);
        }

        Layout.prototype.template = Layout.prototype.templatePath('brute_force_guess/quick/quick_layout');

        Layout.prototype.ui = {
          launch: '.launch-container a'
        };

        Layout.prototype.regions = {
          targetsRegion: '#targets-region',
          credsRegion: "#creds-region",
          optionsRegion: "#options-region",
          breadcrumbRegion: ".row.breadcrumbs"
        };

        Layout.prototype.triggers = {
          'click @ui.launch': 'launch:clicked'
        };

        Layout.prototype.enableLaunch = function() {
          return this.ui.launch.removeClass('disabled');
        };

        Layout.prototype.disableLaunch = function() {
          return this.ui.launch.addClass('disabled');
        };

        Layout.prototype.showErrors = function(errors) {
          var _this = this;
          $('.error', this.el).remove();
          return _.each(errors, function(v, k) {
            if (typeof v === "object") {
              return _this._renderError(v, k);
            }
          });
        };

        Layout.prototype._renderError = function(obj, key) {
          var _this = this;
          return _.each(obj, function(v, k) {
            var $msg;
            if (typeof v === "object" && (v != null)) {
              return _this._renderError(v, "" + key + "[" + k + "]");
            } else {
              if (v != null) {
                if (typeof k === "number") {
                  $msg = $('<div />', {
                    "class": 'error'
                  }).text(v);
                  $("[name='" + key + "']", _this.el).addClass('invalid').after($msg);
                  return $("[name='" + key + "[]']", _this.el).first().addClass('invalid').after($msg);
                }
              }
            }
          });
        };

        return Layout;

      })(App.Views.Layout);
      Quick.TargetsView = (function(_super) {

        __extends(TargetsView, _super);

        function TargetsView() {
          return TargetsView.__super__.constructor.apply(this, arguments);
        }

        TargetsView.prototype.template = TargetsView.prototype.templatePath('brute_force_guess/quick/targets_view');

        TargetsView.prototype.ui = {
          targetRadio: '[name="quick_bruteforce[targets][type]"]:checked',
          targetText: '#manual-target-entry',
          addresses: '.addresses',
          blacklistTargetText: '#manual-target-entry-blacklist',
          allServices: '.all-services',
          services: '.services input:not(.all-services)',
          serviceInputs: '.services input',
          targetCount: '.target-count',
          enterTargetAddresses: 'input.manual-hosts'
        };

        TargetsView.prototype.regions = {
          targetAddressesTooltipRegion: '.target-addresses-tooltip-region',
          blacklistAddressesTooltipRegion: '.blacklist-addresses-tooltip-region'
        };

        TargetsView.prototype.events = {
          'change @ui.targetRadio': '_showHideTargetText',
          'change @ui.allServices': '_selectDeselectServices'
        };

        TargetsView.prototype.triggers = {
          'focusout @ui.targetText': 'countTargets',
          'focusout @ui.blacklistTargetText': 'countTargets',
          'change @ui.serviceInputs': 'countTargets'
        };

        TargetsView.prototype.initialize = function() {
          return this.targetCount = 0;
        };

        TargetsView.prototype.setTargetCount = function(count) {
          this.targetCount = count;
          this.ui.targetCount.html(count);
          return this.trigger('targetCount:update');
        };

        TargetsView.prototype.restoreUIState = function() {
          this.bindUIElements();
          return this.ui.targetRadio.trigger('change');
        };

        TargetsView.prototype.populateAddresses = function(addresses) {
          var _this = this;
          _.each(addresses, function(address) {
            return _this.ui.targetText.val(_this.ui.targetText.val() + address + '\n');
          });
          this.ui.enterTargetAddresses.prop('checked', 'checked');
          return this.ui.enterTargetAddresses.trigger('change');
        };

        TargetsView.prototype._showHideTargetText = function(e) {
          this.trigger('countTargets');
          if ($(e.target).val() === "all") {
            return this.ui.addresses.hide();
          } else {
            return this.ui.addresses.show();
          }
        };

        TargetsView.prototype._selectDeselectServices = function(e) {
          if ($(e.target).prop('checked')) {
            return this.ui.services.prop('checked', true);
          } else {
            return this.ui.services.prop('checked', false);
          }
        };

        return TargetsView;

      })(App.Views.Layout);
      Quick.CredsView = (function(_super) {

        __extends(CredsView, _super);

        function CredsView() {
          this._terminateCred = __bind(this._terminateCred, this);

          this._countCreds = __bind(this._countCreds, this);

          this._showLoading = __bind(this._showLoading, this);

          this._focusOutTextArea = __bind(this._focusOutTextArea, this);
          return CredsView.__super__.constructor.apply(this, arguments);
        }

        CredsView.prototype.template = CredsView.prototype.templatePath('brute_force_guess/quick/creds_view');

        CredsView.prototype.ui = {
          import_cred_pairs: '[name="quick_bruteforce[creds][add_import_cred_pairs]"]',
          import_cred_pairs_text: '.manual-cred-pair',
          import_workspace_creds: '[name="quick_bruteforce[creds][import_workspace_creds]"]',
          fileInput: '#file_input',
          textArea: '#manual-cred-pair-entry',
          textAreaCount: '[name="text_area_count"]',
          textAreaDisabled: '[name="text_area_status"]',
          importPairCount: '[name="import_pair_count"]',
          filePairCount: '[name="file_pair_count"]',
          cloneFileWarning: '[name="clone_file_warning"]',
          credCount: '.cred-count',
          countFuzz: '.count .fuzz',
          lastUploaded: '.last-uploaded',
          useLastUploaded: '[name="quick_bruteforce[use_last_uploaded]"]',
          useFileContents: '[name="quick_bruteforce[creds][import_cred_pairs][use_file_contents]"]',
          mutationLabel: '.mutation-label',
          defaultsLabel: '.defaults-label',
          fileCancel: '.cancel.file-input',
          factoryDefault: '[name="quick_bruteforce[creds][factory_defaults]"]',
          blankAsPassword: '[name="quick_bruteforce[creds][import_cred_pairs][blank_as_password]"]',
          usernameAsPassword: '[name="quick_bruteforce[creds][import_cred_pairs][username_as_password]"]'
        };

        CredsView.prototype.events = {
          'change @ui.import_cred_pairs': '_showHideCredText',
          'change @ui.import_workspace_creds': '_import_workspace_creds',
          'keyup @ui.textArea': '_credChanged',
          'change @ui.blankAsPassword': '_changeRule',
          'change @ui.usernameAsPassword': '_changeRule',
          'change @ui.factoryDefault': '_changeFactoryDefault'
        };

        CredsView.prototype.triggers = {
          'click @ui.fileCancel': 'fileInput:clear'
        };

        CredsView.prototype.regions = {
          fileUploadRegion: '.file-upload-region'
        };

        CredsView.include('TextAreaLimit');

        CredsView.prototype.initialize = function() {
          this.file_cred_count = 0;
          this.text_area_count = 0;
          this.shown_cred_count = 0;
          this.workspace_cred_count = 0;
          this.import_cred_pairs_count = 0;
          this.restored_import_cred_pairs_count = 0;
          this.is_task_chain = this.model.get('is_task_chain');
          return this.debouncedChangeEvent = _.debounce(this._countCreds, 300);
        };

        CredsView.prototype.onShow = function() {
          this._bindTextArea(this.ui.textArea, 100, Quick.CredLimitView);
          if (!this.is_task_chain) {
            return $('.cred-file-upload-region').css('display', 'inline-block');
          }
        };

        CredsView.prototype.onDestroy = function() {
          return this._unbindTextArea(this.ui.textArea);
        };

        CredsView.prototype.hideMutationLabel = function() {
          this._fuzzComboCount(false);
          return this.ui.mutationLabel.css('display', 'none');
        };

        CredsView.prototype.showMutationLabel = function() {
          this._fuzzComboCount();
          return this.ui.mutationLabel.css('display', 'inline-block');
        };

        CredsView.prototype.showFactoryDefaultsLabel = function() {
          this._fuzzComboCount();
          return this.ui.defaultsLabel.css('display', 'inline-block');
        };

        CredsView.prototype.hideFactoryDefaultsLabel = function() {
          this._fuzzComboCount(false);
          return this.ui.defaultsLabel.css('display', 'none');
        };

        CredsView.prototype.factoryDefaultChecked = function() {
          return this.ui.factoryDefault.prop('checked');
        };

        CredsView.prototype.showFileCancel = function(bool) {
          if (bool == null) {
            bool = true;
          }
          if (bool) {
            return this.ui.fileCancel.css('visibility', 'visible');
          } else {
            this.ui.fileCancel.css('visibility', 'hidden');
            return $('.error', this.el).remove();
          }
        };

        CredsView.prototype.useLastUploaded = function(fileName) {
          this.lastUploaded = fileName;
          this.ui.lastUploaded.show();
          this.ui.lastUploaded.text("Last Uploaded: " + fileName);
          return this.ui.useLastUploaded.val(fileName);
        };

        CredsView.prototype.restoreUIState = function(opts) {
          if (opts == null) {
            opts = {};
          }
          if (this.ui.cloneFileWarning.val() === "true") {
            this._showFileWarning();
            this.ui.cloneFileWarning.val(false);
          }
          this.ui.textArea.trigger('focusout');
          if ($('[name="quick_bruteforce[options][mutation]"]').prop("checked")) {
            this.showMutationLabel();
          }
          if (this.ui.factoryDefault.prop("checked")) {
            this.showFactoryDefaultsLabel();
          }
          this.ui.import_cred_pairs.trigger('change');
          this.ui.import_workspace_creds.trigger('change');
          if (this.ui.textAreaDisabled.val() === 'true') {
            this._disableTextArea();
          }
          this.restoreLastUploaded();
          if (opts.restoreFileInput) {
            return this.fileChanged();
          } else {
            return this.restoreImportCount();
          }
        };

        CredsView.prototype.restoreImportCount = function() {
          this.restored_import_cred_pairs_count = parseInt(this.ui.importPairCount.val()) || 0;
          this.file_cred_count = parseInt(this.ui.filePairCount.val()) || 0;
          return this._updateCredCount(this.restored_import_cred_pairs_count + this.workspace_cred_count);
        };

        CredsView.prototype.restoreLastUploaded = function() {
          if (this.ui.useLastUploaded.val() !== '') {
            return this.useLastUploaded(this.ui.useLastUploaded.val());
          } else {
            return this.ui.lastUploaded.hide();
          }
        };

        CredsView.prototype.getComboCount = function() {
          return parseInt(this.ui.credCount.html());
        };

        CredsView.prototype.resetFileCount = function() {
          this.file_cred_count = 0;
          return this._countCreds();
        };

        CredsView.prototype._changeFactoryDefault = function(e) {
          if ($(e.target).prop('checked')) {
            return this.showFactoryDefaultsLabel();
          } else {
            return this.hideFactoryDefaultsLabel();
          }
        };

        CredsView.prototype.isFuzzed = function() {
          return parseInt(this.ui.countFuzz.data('count')) > 0;
        };

        CredsView.prototype._fuzzComboCount = function(show) {
          if (show == null) {
            show = true;
          }
          if (show) {
            this.ui.countFuzz.data('count', parseInt(this.ui.countFuzz.data('count') || 0) + 1);
            this.ui.countFuzz.show();
          } else {
            this.ui.countFuzz.data('count', parseInt(this.ui.countFuzz.data('count') || 0) - 1);
            if (parseInt(this.ui.countFuzz.data('count')) === 0) {
              this.ui.countFuzz.hide();
            }
          }
          return this.trigger('credCount:update');
        };

        CredsView.prototype._credChanged = function() {
          return this.debouncedChangeEvent();
        };

        CredsView.prototype._focusOutTextArea = function(e) {
          return this._terminateCred(e);
        };

        CredsView.prototype._import_workspace_creds = function(e) {
          if ($(e.target).prop('checked')) {
            this.workspace_cred_count = this.model.get('workspace_cred_count');
            return this._updateCredCount(this.import_cred_pairs_count + this.workspace_cred_count);
          } else {
            this.workspace_cred_count = 0;
            return this._updateCredCount(this.import_cred_pairs_count);
          }
        };

        CredsView.prototype._showFileWarning = function() {
          $(".file-upload-region label", this.el).css({
            'border-color': 'red'
          });
          $(".file-upload-region span", this.el).css({
            'border-color': 'red',
            'border-left-color': '#666'
          });
          $(".file-upload-region").append("<div class='error' style='color:red;'>Please re-select file</div>");
          return $(".columns.small-12>.errors").replaceWith('<div class="errors" style="display: block;">The file you selected cannot be cloned. Please re-select the file.</div>');
        };

        CredsView.prototype._showHideCredText = function(e) {
          if ($(e.target).prop('checked')) {
            this.import_cred_pairs_count = this.file_cred_count + this.text_area_count + this.restored_import_cred_pairs_count;
            this._updateCredCount(this.import_cred_pairs_count + this.workspace_cred_count);
            return this.ui.import_cred_pairs_text.show();
          } else {
            this.import_cred_pairs_count = 0;
            this._updateCredCount(this.workspace_cred_count);
            return this.ui.import_cred_pairs_text.hide();
          }
        };

        CredsView.prototype.clearLastUploaded = function() {
          this.ui.lastUploaded.hide();
          return $('.error', this.el).remove();
        };

        CredsView.prototype._disableTextArea = function() {
          this.ui.textAreaDisabled.val(true);
          this.ui.textArea.addClass('disabled');
          return this.ui.textArea.prop('disabled', true);
        };

        CredsView.prototype._enableTextArea = function() {
          this.ui.textAreaDisabled.val(false);
          this.ui.textArea.removeClass('disabled');
          return this.ui.textArea.prop('disabled', false);
        };

        CredsView.prototype.fileChanged = function() {
          var file;
          this.bindUIElements();
          this.clearLastUploaded();
          this.file_cred_count = 0;
          file = this.ui.fileInput[0].files[0];
          if ((file != null) && file.name.match(/.txt/)) {
            this.ui.cloneFileWarning.val(true);
            return this._parseCreds(file);
          } else {
            return this._countCreds();
          }
        };

        CredsView.prototype._parseCreds = function(file) {
          var blob, byte, chunk_reader, file_size, file_type, _i, _results;
          file_size = file.size;
          file_type = file.type;
          _results = [];
          for (byte = _i = 0; 0 <= file_size ? _i <= file_size : _i >= file_size; byte = _i += CHUNK_SIZE) {
            blob = file.slice(byte, byte + CHUNK_SIZE);
            chunk_reader = new FileReader();
            chunk_reader.onloadstart = this._showLoading;
            chunk_reader.onloadend = this._countCreds;
            _results.push(chunk_reader.readAsText(blob));
          }
          return _results;
        };

        CredsView.prototype._showLoading = function() {
          return this.ui.textArea.addClass('tab-loading');
        };

        CredsView.prototype._changeRule = function() {
          this.fileChanged();
          return this._countCreds();
        };

        CredsView.prototype._countCreds = function(e) {
          this.ui.textArea.removeClass('tab-loading');
          if (e != null) {
            this.file_cred_count = this.file_cred_count + this._textAreaCount(e.target.result);
          } else {
            this.text_area_count = this._textAreaCount(this.ui.textArea.val());
          }
          this.import_cred_pairs_count = this.file_cred_count + this.text_area_count;
          this.restored_import_cred_pairs_count = 0;
          this.ui.importPairCount.val(this.import_cred_pairs_count);
          this.ui.textAreaCount.val(this.text_area_count);
          this.ui.filePairCount.val(this.file_cred_count);
          return this._updateCredCount(this.import_cred_pairs_count + this.workspace_cred_count);
        };

        CredsView.prototype._textAreaCount = function(val) {
          var count, lines,
            _this = this;
          count = 0;
          lines = val.match(/(([^\s]+(([\u0020]+[^\s]+)+)))|([^\s]+)/g);
          _.each(lines, function(elem) {
            var c, i, inQuote, inToken, passwordCount, _i, _ref;
            passwordCount = -1;
            inQuote = 0;
            inToken = 0;
            for (i = _i = 0, _ref = elem.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
              c = elem[i];
              if (inQuote === 1) {
                if (c === "\"") {
                  inQuote = 0;
                }
                continue;
              }
              if (c === " " || c === "\t") {
                inToken = 0;
                continue;
              }
              if (inToken === 0) {
                inToken = 1;
                passwordCount = passwordCount + 1;
              }
              if (c === "\"") {
                inQuote = 1;
              }
            }
            if (_this.ui.usernameAsPassword.prop('checked')) {
              passwordCount = passwordCount + 1;
            }
            if (_this.ui.blankAsPassword.prop('checked')) {
              passwordCount = passwordCount + 1;
            }
            return count = count + passwordCount;
          });
          return count;
        };

        CredsView.prototype._terminateCred = function(e) {
          var val;
          val = $(e.target).val();
          if (val.length > 2 && val.substring(val.length - 1, val.length) !== "\n") {
            this.ui.textArea.val(val + '\n');
            return this.ui.textArea.trigger('keyup');
          }
        };

        CredsView.prototype._updateCredCount = function(count) {
          this.ui.credCount.html(_.escape(count));
          return this.trigger('credCount:update');
        };

        return CredsView;

      })(App.Views.Layout);
      Quick.OptionsView = (function(_super) {

        __extends(OptionsView, _super);

        function OptionsView() {
          return OptionsView.__super__.constructor.apply(this, arguments);
        }

        OptionsView.prototype.template = OptionsView.prototype.templatePath('brute_force_guess/quick/options_view');

        OptionsView.prototype.ui = {
          form: 'form',
          payloadCheckBox: 'input[name="quick_bruteforce[options][payload_settings]"]',
          mutationCheckBox: 'input[name="quick_bruteforce[options][mutation]"]',
          hour: 'input[name="quick_bruteforce[options][overall_timeout][hour]"]',
          minutes: 'input[name="quick_bruteforce[options][overall_timeout][minutes]"]',
          seconds: 'input[name="quick_bruteforce[options][overall_timeout][seconds]"]',
          serviceTimeout: 'input[name="quick_bruteforce[options][service_timeout]"]'
        };

        OptionsView.prototype.regions = {
          overallTimeoutTooltipRegion: '.overall-timeout-tooltip-region',
          serviceTimeoutTooltipRegion: '.service-timeout-tooltip-region',
          timeTooltipRegion: '.time-tooltip-region',
          mutationTooltipRegion: '.mutation-tooltip-region',
          sessionTooltipRegion: '.session-tooltip-region'
        };

        OptionsView.prototype.events = {
          'input @ui.hour': '_parseOptions',
          'input @ui.minutes': '_parseOptions',
          'input @ui.seconds': '_parseOptions',
          'input @ui.serviceTimeout': '_parseOptions'
        };

        OptionsView.prototype.triggers = {
          'change @ui.payloadCheckBox ': 'payloadSettings:show',
          'change @ui.mutationCheckBox': 'mutationOptions:show'
        };

        OptionsView.prototype.deselectPayload = function() {
          return this.ui.payloadCheckBox.prop('checked', false);
        };

        OptionsView.prototype.isPayloadSettingsSelected = function() {
          return this.ui.payloadCheckBox.prop('checked');
        };

        OptionsView.prototype.isMutationCheckboxSelected = function() {
          return this.ui.mutationCheckBox.prop('checked');
        };

        OptionsView.prototype._parseOptions = function(e) {
          return $(e.target).val($(e.target).val().replace(/[^0-9]/g, ''));
        };

        return OptionsView;

      })(App.Views.Layout);
      Quick.ConfirmationView = (function(_super) {

        __extends(ConfirmationView, _super);

        function ConfirmationView() {
          return ConfirmationView.__super__.constructor.apply(this, arguments);
        }

        ConfirmationView.prototype.template = ConfirmationView.prototype.templatePath('brute_force_guess/quick/confirmation_view');

        ConfirmationView.prototype.className = 'confirmation-view';

        ConfirmationView.prototype.onFormSubmit = function() {
          var defer, formSubmit;
          defer = $.Deferred();
          formSubmit = function() {};
          defer.promise(formSubmit);
          defer.resolve();
          this.trigger("launch");
          return formSubmit;
        };

        return ConfirmationView;

      })(App.Views.ItemView);
      Quick.MutationView = (function(_super) {

        __extends(MutationView, _super);

        function MutationView() {
          return MutationView.__super__.constructor.apply(this, arguments);
        }

        MutationView.prototype.template = MutationView.prototype.templatePath('brute_force_guess/quick/mutation_view');

        MutationView.prototype.className = 'mutation-options';

        MutationView.prototype.onRender = function() {
          return Backbone.Syphon.deserialize(this, this.model.toJSON());
        };

        MutationView.prototype.onFormSubmit = function() {
          var defer, formSubmit;
          defer = $.Deferred();
          formSubmit = function() {};
          defer.promise(formSubmit);
          this._serializeForm();
          defer.resolve();
          return defer;
        };

        MutationView.prototype._serializeForm = function() {
          return this.model.set(Backbone.Syphon.serialize(this));
        };

        return MutationView;

      })(App.Views.ItemView);
      return Quick.CredLimitView = (function(_super) {

        __extends(CredLimitView, _super);

        function CredLimitView() {
          return CredLimitView.__super__.constructor.apply(this, arguments);
        }

        CredLimitView.prototype.template = CredLimitView.prototype.templatePath('brute_force_guess/quick/cred_limit_view');

        CredLimitView.prototype.className = 'cred-limit-view';

        CredLimitView.prototype.onFormSubmit = function() {
          var defer, formSubmit;
          defer = $.Deferred();
          formSubmit = function() {};
          defer.promise(formSubmit);
          defer.resolve();
          defer;

          return formSubmit;
        };

        return CredLimitView;

      })(App.Views.ItemView);
    });
  });

}).call(this);
