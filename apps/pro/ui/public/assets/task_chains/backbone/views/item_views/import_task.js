(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/task_chains/item_views/import_task-4f712204588777b78de08011a00c21285ff345f62e63cc5fbfd13e4173ab98f4.js', '/assets/task_chains/backbone/views/item_views/task_config-458520c231172701b05b17eb4ec828171c6e0745e4b3d3c11327d01af916a52e.js', 'apps/imports/index/index_controller', 'css!css/imports'], function($, Template, TaskConfigView) {
    var ImportTask;
    return ImportTask = (function(_super) {

      __extends(ImportTask, _super);

      function ImportTask() {
        this._bindToFileChange = __bind(this._bindToFileChange, this);

        this._triggerValidated = __bind(this._triggerValidated, this);
        return ImportTask.__super__.constructor.apply(this, arguments);
      }

      ImportTask.prototype.template = HandlebarsTemplates['task_chains/item_views/import_task'];

      ImportTask.prototype.id = 'imports-main-region';

      ImportTask.prototype.ui = _.extend({}, TaskConfigView.prototype.ui, {});

      ImportTask.prototype.events = _.extend({}, TaskConfigView.prototype.events, {});

      ImportTask.prototype._restoreFileLabel = function() {
        return this.controller.fileController.fileInput.resetLabel();
      };

      ImportTask.prototype.isExistingTask = function() {
        return (this.model.get('task') != null) && !(this.form_cache != null);
      };

      ImportTask.prototype.isCachedExistingTask = function() {
        return (this.form_cache != null) && !(this.model.get('cloned') != null);
      };

      ImportTask.prototype.isClonedTask = function() {
        return this.model.get('cloned') != null;
      };

      ImportTask.prototype.showExistingTask = function() {
        var _ref, _ref1;
        this.controller = new Pro.ImportsApp.Index.Controller({
          type: Pro.ImportsApp.Index.Type.File,
          showTypeSelection: false,
          region: this.configRegion
        });
        this.controller.fileController.useLastUploaded(((_ref = this.model.get('task').file_upload) != null ? _ref.url : void 0) || this.model.get('task').form_hash.use_last_uploaded);
        Backbone.Syphon.deserialize(this.controller.fileController._mainView, this.model.get('task').form_hash, {
          include: ["blacklist_string", "use_last_uploaded"]
        });
        this.controller._mainView.ui.autoTagOs.prop('checked', this.model.get('task').form_hash.autotag_os === 'true');
        this.controller._mainView.ui.preserveHosts.prop('checked', this.model.get('task').form_hash.preserve_hosts === 'true');
        if (((_ref1 = this.model.get('task').form_hash.tagTokens) != null ? _ref1.length : void 0) > 0) {
          this.controller.tagController.restoreTokens(this.model.get('task').form_hash.tagTokens);
          this.controller._mainView.expandTagSection();
        }
        this._initErrorMessages();
        return this.trigger('loaded');
      };

      ImportTask.prototype.showCachedExistingTask = function() {
        this.controller = new Pro.ImportsApp.Index.Controller({
          type: Pro.ImportsApp.Index.Type.File,
          showTypeSelection: false,
          region: this.configRegion
        });
        if (this.storedForm.get('use_last_uploaded') != null) {
          this.controller.fileController.useLastUploaded(this.storedForm.get('use_last_uploaded'));
        }
        this._applyStashedFileInput(this.$el);
        this._restoreFileLabel();
        this.controller.fileController.fileInput.rebindFileInput();
        _.defer(this._bindToFileChange, this.controller.fileController.fileInput);
        Backbone.Syphon.deserialize(this.controller.fileController._mainView, this.storedForm.toJSON(), {
          include: ["blacklist_string", "use_last_uploaded"]
        });
        this.controller._mainView.ui.autoTagOs.prop('checked', this.storedForm.get('autotag_os'));
        this.controller._mainView.ui.preserveHosts.prop('checked', this.storedForm.get('preserve_hosts'));
        if (this.storedForm.get('tagTokens').length > 0) {
          this.controller.tagController.restoreTokens(this.storedForm.get('tagTokens'));
          this.controller._mainView.expandTagSection();
        }
        return this._initErrorMessages();
      };

      ImportTask.prototype.showClonedTask = function() {
        var excludeInputs;
        this.controller = new Pro.ImportsApp.Index.Controller({
          type: Pro.ImportsApp.Index.Type.File,
          showTypeSelection: false,
          region: this.configRegion
        });
        excludeInputs = [];
        if (this.model.get('clonedModel').get('use_last_uploaded') === '') {
          excludeInputs << "use_last_uploaded";
        }
        Backbone.Syphon.deserialize(this.controller.fileController._mainView, this.model.get('clonedModel').toJSON(), {
          exclude: excludeInputs
        });
        this.controller._mainView.ui.autoTagOs.prop('checked', this.model.get('clonedModel').get('autotag_os'));
        this.controller._mainView.ui.preserveHosts.prop('checked', this.model.get('clonedModel').get('preserve_hosts'));
        if (this.model.get('clonedModel').get('tagTokens').length > 0) {
          this.controller.tagController.restoreTokens(this.model.get('clonedModel').get('tagTokens'));
          this.controller._mainView.expandTagSection();
        }
        return this.model.set('cloned', null);
      };

      ImportTask.prototype.showNewTask = function() {
        return this.controller = new Pro.ImportsApp.Index.Controller({
          type: Pro.ImportsApp.Index.Type.File,
          showTypeSelection: false,
          region: this.configRegion
        });
      };

      ImportTask.prototype.onShow = function() {
        if (this.isExistingTask()) {
          return this.showExistingTask();
        } else {
          if (this.isCachedExistingTask()) {
            return this.showCachedExistingTask();
          } else {
            if (this.isClonedTask()) {
              return this.showClonedTask();
            } else {
              return this.showNewTask();
            }
          }
        }
      };

      ImportTask.prototype._initErrorMessages = function() {
        if (this.errors) {
          return this.controller.fileController._mainView.showErrors(this.errors);
        }
      };

      ImportTask.prototype._storeForm = function(opts) {
        var file_path;
        if (opts == null) {
          opts = {
            callSuper: true
          };
        }
        if (opts.callSuper) {
          ImportTask.__super__._storeForm.apply(this, arguments);
        }
        this.storedForm = this.controller.getFileImportEntity();
        file_path = this.controller.fileController._mainView.lastUploaded;
        if ((file_path != null) && file_path !== '') {
          this.storedForm.set('use_last_uploaded', file_path);
        }
        return this.storedForm.set({
          tagTokens: this.controller.tagController.getTokens()
        });
      };

      ImportTask.prototype.formModel = function() {
        return this.storedForm || this.controller.getFileImportEntity();
      };

      ImportTask.prototype._setCache = function() {
        return ImportTask.__super__._setCache.apply(this, arguments);
      };

      ImportTask.prototype.onBeforeClose = function() {
        ImportTask.__super__.onBeforeClose.apply(this, arguments);
        return this._validate();
      };

      ImportTask.prototype._triggerValidated = function(model, response, options) {
        if (response.errors) {
          this.errors = response.errors;
          $(document).trigger('showErrorPie', this);
        } else {
          this.errors = null;
        }
        return $(document).trigger('validated', this);
      };

      ImportTask.prototype._bindToFileChange = function(fileInput) {
        return this.listenTo(fileInput._mainView, 'file:changed', function() {
          return this.controller.fileController.clearLastUploaded();
        });
      };

      ImportTask.prototype._validate = function() {
        if (this.storedForm != null) {
          this.controller.validate(this._triggerValidated, this.storedForm);
        }
        this.bindUIElements();
        return this._stashFileInput();
      };

      return ImportTask;

    })(TaskConfigView);
  });

}).call(this);
