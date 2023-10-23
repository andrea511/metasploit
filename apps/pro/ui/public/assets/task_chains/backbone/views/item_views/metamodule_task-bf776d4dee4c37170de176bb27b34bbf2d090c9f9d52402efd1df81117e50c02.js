(function() {
  var modalViewPaths,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  modalViewPaths = {
    "firewall_egress": "/assets/firewall_egress/firewall_egress-41aa491fc93a00a990b0b8d0be32d746b97ce4c16afe45c55cbad3431b33293a.js",
    "domino": "/assets/domino/domino-7a82751ce0e6cd898ba2dd086b859b273191d37a09e3b60d0af3ff77f4b2c2b5.js",
    "pass_the_hash": "/assets/apps/backbone/views/modal_views/pass_the_hash-b92b02d88c6a8c50949f1ed50fb3cc77905a6330ad2351f7a08ac38101a4baa1.js",
    "ssh_key": "/assets/apps/backbone/views/modal_views/ssh_key-160a37ba88ac80f734c559bd37a41b094233b6c6111bff2fab8cc801aa7e1676.js",
    "credential_intrusion": "/assets/apps/backbone/views/modal_views/credential_intrusion-75b55e9fefd5fda1eb9b858b7dd0edb83d6f1b8b792f11722f6a0bc4d3c7b622.js",
    "single_password": "/assets/apps/backbone/views/modal_views/single_password-89408bd5ea92a8563da2d31fdfc5042b261ed127adbb34f7a987883422377502.js",
    "passive_network": "/assets/apps/backbone/views/modal_views/passive_network-fa4ee0811dadc1cc7a1649db551036e353ebbaac1c9b2b9ef2c6b58e7fb669a9.js"
  };

  define(['jquery', '/assets/templates/task_chains/item_views/metamodule_task-772fff793577c85665c3e007b764441ed00fe11f96b2a6ddc03171f23a36ed65.js', '/assets/task_chains/backbone/views/item_views/task_config-458520c231172701b05b17eb4ec828171c6e0745e4b3d3c11327d01af916a52e.js', '/assets/apps/backbone/views/modal_views/pass_the_hash-b92b02d88c6a8c50949f1ed50fb3cc77905a6330ad2351f7a08ac38101a4baa1.js'], function($, Template, TaskConfigView, PassTheHash) {
    var MetaModuleTask;
    return MetaModuleTask = (function(_super) {

      __extends(MetaModuleTask, _super);

      function MetaModuleTask() {
        this._mmValidated = __bind(this._mmValidated, this);
        return MetaModuleTask.__super__.constructor.apply(this, arguments);
      }

      MetaModuleTask.prototype.template = HandlebarsTemplates['task_chains/item_views/metamodule_task'];

      MetaModuleTask.prototype.ui = _.extend({}, TaskConfigView.prototype.ui, {
        mm_select: '.mm-select',
        file_upload_path: '.file_upload_path',
        file: '#task_config_key_file',
        use_last_uploaded: '#task_config_use_last_uploaded'
      });

      MetaModuleTask.prototype.events = _.extend({}, TaskConfigView.prototype.events, {
        'change @ui.mm_select': '_mmChanged',
        'tabbed-modal-loaded @ui.config': '_mmLoaded',
        'change @ui.file': '_setFileUploadPath',
        'tableload @ui.config': '_setSelectedCred',
        'click .stored .dataTables_wrapper tr': '_rowClicked'
      });

      MetaModuleTask.prototype.initialize = function() {
        this.runValidations = false;
        return this.enableHiddenCred = true;
      };

      MetaModuleTask.prototype.onBeforeRender = function() {
        return this.model.set('metamodules', gon.metamodules);
      };

      MetaModuleTask.prototype.onShow = function() {
        var clonedNode, mm_symbol, path;
        this._unbindTriggers();
        this.undelegateEvents();
        this.delegateEvents();
        this._bindTriggers();
        this._initErrorMessages();
        if (this.model.get('task') != null) {
          this.task_config_id = this.model.get('task').id;
          mm_symbol = this.model.get("task").form_hash.mm_symbol;
          this.ui.mm_select.val(mm_symbol);
        }
        if (this.model.get('cloned') != null) {
          clonedNode = this.model.get('clonedConfigNode');
          this.cachedNode = $('.padding>.content form', clonedNode)[0];
          this.model.set('cloned', null);
          this.ui.mm_select.val($('[name="task_config[mm_symbol]"]', clonedNode).val());
        }
        if (this.selectedMM != null) {
          this.ui.mm_select.val(this.selectedMM);
        }
        path = modalViewPaths[this.ui.mm_select.val()];
        if (this.MM != null) {
          this.mm.close();
          this.bindUIElements();
          $('li.slider div', this.cachedNode).remove();
          if (this.cachedNode != null) {
            this.runValidations = true;
          }
          this.mm = new this.MM({
            el: this.ui.config,
            appendToEl: true,
            cachedNode: this.cachedNode,
            taskConfigId: this.task_config_id
          }).open();
          $('.tabbed-modal', this.el).css('position', 'static');
          $('.tabbed-modal', this.el).css('border', '0px');
          $('.bg', this.el).remove();
          return this.cachedNode = $('.padding>.content form', this.el)[0];
        } else {
          return this._loadMetaModule(path);
        }
      };

      MetaModuleTask.prototype._bindTriggers = function() {
        return $(document).on("tabbedModalValidated", this._mmValidated);
      };

      MetaModuleTask.prototype._unbindTriggers = function() {
        return $(document).off("tabbedModalValidated", this._mmValidated);
      };

      MetaModuleTask.prototype._loadMetaModule = function(path, clearCache) {
        var rjs,
          _this = this;
        if (clearCache == null) {
          clearCache = false;
        }
        rjs = requirejs.config({
          context: 'app'
        });
        return rjs([path], function(MM) {
          _this.MM = MM;
          if (_this.mm != null) {
            _this.mm.close();
          }
          _this.bindUIElements();
          if (clearCache) {
            _this.cachedNode = void 0;
          }
          if (_this.cachedNode != null) {
            _this.runValidations = true;
            $('li.slider div', _this.cachedNode).remove();
          }
          _this.mm = new MM({
            el: _this.ui.config,
            appendToEl: true,
            cachedNode: _this.cachedNode,
            taskConfigId: _this.task_config_id
          }).open();
          _this._mmValidated(null, _this.mm);
          $('.tabbed-modal', _this.el).css('position', 'static');
          $('.tabbed-modal', _this.el).css('border', '0px');
          return $('.bg', _this.el).remove();
        });
      };

      MetaModuleTask.prototype._mmValidated = function(e, mm) {
        if (this.mm === mm || ((this.mm != null) && (mm != null) && (this.mm.taskConfigId != null) && this.mm.taskConfigId === mm.taskConfigId)) {
          helpers.hideLoadingDialog.call(this);
          this.errors = mm.errors;
          if ((this.errors != null) && ($(this.el).filter(':visible').length === 0 || this._hasTabErrors(mm) || $('.hasErrors', this.el).filter(':visible').length > 0)) {
            this.errors = "Correct Errors Below";
            $(document).trigger('showErrorPie', this);
          } else {
            this.errors = null;
            $(document).trigger('clearErrorPie', this);
          }
          this._initErrorMessages();
          return $(document).trigger('validated', this);
        }
      };

      MetaModuleTask.prototype._hasTabErrors = function(mm) {
        var $page, errorCount;
        $page = $(mm.pageAt(mm._tabIdx));
        errorCount = 0;
        _.each(mm.errors, function(value, key, list) {
          return _.each(list[key], function(value, key2, list) {
            if ($(".error [name='" + key + "[" + key2 + "]']", $page).length > 0) {
              return errorCount++;
            }
          });
        });
        if (errorCount > 0) {
          return true;
        } else {
          return false;
        }
      };

      MetaModuleTask.prototype._mmLoaded = function() {
        var noFiles;
        this.bindUIElements();
        $('.inline-error', this.mm.$el).each(function(k, v) {
          return v.remove();
        });
        noFiles = this.selectedMM === 'ssh_key' && ((!(this.ui.use_last_uploaded.val() != null)) || (this.ui.use_last_uploaded.val() === 'false')) ? false : true;
        this._applyStashedFileInput(this.ui.form[0]);
        this.mm.renderFileInputs();
        if (this.runValidations) {
          helpers.hideLoadingDialog.call(this);
          helpers.showLoadingDialog.call(this, 'Validating...');
          this.mm.validate({
            noFiles: noFiles
          });
        }
        this.runValidations = true;
        this.bindUIElements();
        this.undelegateEvents();
        this.delegateEvents();
        this.ui.form.append("<input type='hidden' name='task_config[task_chain]' value='true'>");
        this.ui.form.append("<input type='hidden' name='task_config[mm_symbol]' value='" + (this.ui.mm_select.val()) + "'>");
        return this.trigger('loaded');
      };

      MetaModuleTask.prototype._mmChanged = function(e) {
        var path;
        path = modalViewPaths[$(e.target).val()];
        this.task_config_id = void 0;
        this.runValidations = false;
        return this._loadMetaModule(path, true);
      };

      MetaModuleTask.prototype._storeForm = function() {
        this.storedForm = this.ui.form[0] ? helpers.cloneNodeAndForm(this.ui.form[0]) : void 0;
        return this.fileInputs = this.ui.file_inputs;
      };

      MetaModuleTask.prototype._setCache = function() {
        this.form_cache = helpers.cloneNodeAndForm(this.ui.config[0]);
        return this._storeForm();
      };

      MetaModuleTask.prototype.onBeforeClose = function() {
        var noFiles;
        this.bindUIElements();
        this._setCache();
        this.selectedMM = this.ui.mm_select.val();
        $('[name="task_config[mm_symbol]"]', this.el).val(this.ui.mm_select.val());
        if (this.mm) {
          if (this.mm._steps.length !== 0) {
            $('.inline-error', this.mm.$el).each(function(k, v) {
              return v.remove();
            });
            noFiles = this.selectedMM === 'ssh_key' && ((!(this.ui.use_last_uploaded.val() != null)) || (this.ui.use_last_uploaded.val() === 'false')) ? false : true;
            if (this.runValidations) {
              helpers.showLoadingDialog.call(this, 'Validating...');
              this.mm.validate({
                noFiles: noFiles
              });
            }
          }
        }
        this.cachedNode = $('.padding>.content form', this.el) != null ? helpers.cloneNodeAndForm($('.padding>.content form', this.el)[0]) : void 0;
        this._stashFileInput();
        if (this.mm) {
          return this.mm.close();
        }
      };

      MetaModuleTask.prototype._setFileUploadPath = function() {
        this.ui.file_upload_path.html(this.ui.file.val().split('\\').pop());
        return this.ui.use_last_uploaded.val(false);
      };

      MetaModuleTask.prototype._setSelectedCred = function() {
        if ((this.mm.setHiddenCred != null) && this.enableHiddenCred && this.task_config_id && this.model.get('task')['form_hash']['cred_type'] === "stored") {
          return this.mm.setHiddenCred(this.model.get('task')['form_hash']);
        }
      };

      MetaModuleTask.prototype._rowClicked = function() {
        if (this.mm.removeHiddenCred != null) {
          this.enableHiddenCred = false;
          return this.mm.removeHiddenCred();
        }
      };

      return MetaModuleTask;

    })(TaskConfigView);
  });

}).call(this);
