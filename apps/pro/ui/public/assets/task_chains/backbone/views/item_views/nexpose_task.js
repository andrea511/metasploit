(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/task_chains/item_views/nexpose_task-ead64dcbc9d0d8fce3b4bc9da8e6610bc7a286c29c05ce6ee2f57bd3f84ed4bb.js', '/assets/task_chains/backbone/views/item_views/task_config-458520c231172701b05b17eb4ec828171c6e0745e4b3d3c11327d01af916a52e.js', 'apps/imports/index/index_controller', 'css!css/imports'], function($, Template, TaskConfigView) {
    var NexposeTask;
    return NexposeTask = (function(_super) {

      __extends(NexposeTask, _super);

      function NexposeTask() {
        this._validate = __bind(this._validate, this);

        this._triggerValidated = __bind(this._triggerValidated, this);

        this.isClonedTask = __bind(this.isClonedTask, this);

        this.isCachedExistingTask = __bind(this.isCachedExistingTask, this);

        this.isExistingTask = __bind(this.isExistingTask, this);

        this._setTable = __bind(this._setTable, this);

        this._triggerRowsSelected = __bind(this._triggerRowsSelected, this);

        this._bindTableListener = __bind(this._bindTableListener, this);
        return NexposeTask.__super__.constructor.apply(this, arguments);
      }

      NexposeTask.prototype.template = HandlebarsTemplates['task_chains/item_views/nexpose_task'];

      NexposeTask.prototype.id = 'imports-main-region';

      NexposeTask.prototype.VALIDATION_URL = "/workspaces/" + WORKSPACE_ID + "/tasks/validate_nexpose";

      NexposeTask.prototype.onShow = function() {
        if (this.isExistingTask()) {
          this.showExistingTask();
        } else {
          if (this.isCachedExistingTask()) {
            this.showCachedExistingTask();
          } else {
            if (this.isClonedTask()) {
              this.showClonedTask();
            } else {
              this.showNewTask();
            }
          }
        }
        return this._bindTableListener();
      };

      NexposeTask.prototype._bindTableListener = function() {
        var _this = this;
        return this.controller.nexposeController.once('nexposeSites:initialized', function() {
          _this.listenToOnce(_this.controller.nexposeController.nexposeSites._mainView.table.tableCollection, 'sync', function() {
            _this.trigger('loaded');
            return _this._storeView();
          });
          _this.controller.nexposeController._mainView.nexposeSitesRegion.currentView.table.carpenterRadio.on('table:rows:selected', _this._triggerRowsSelected);
          _this.controller.nexposeController._mainView.nexposeSitesRegion.currentView.table.carpenterRadio.on('table:rows:deselected', _this._triggerRowsSelected);
          _this.controller.nexposeController._mainView.nexposeSitesRegion.currentView.table.carpenterRadio.on('table:row:selected', _this._triggerRowsSelected);
          return _this.controller.nexposeController._mainView.nexposeSitesRegion.currentView.table.carpenterRadio.on('table:row:deselected', _this._triggerRowsSelected);
        });
      };

      NexposeTask.prototype._triggerRowsSelected = function() {
        return this._storeView();
      };

      NexposeTask.prototype.showNewTask = function() {
        this.controller = new Pro.ImportsApp.Index.Controller({
          type: Pro.ImportsApp.Index.Type.Nexpose,
          showTypeSelection: false,
          region: this.configRegion
        });
        return this.trigger('loaded');
      };

      NexposeTask.prototype.showExistingTask = function() {
        var _ref, _ref1;
        this.controller = new Pro.ImportsApp.Index.Controller({
          type: Pro.ImportsApp.Index.Type.Nexpose,
          showTypeSelection: false,
          region: this.configRegion
        });
        this._initErrorMessages();
        this.storedForm = new Pro.Entities.Nexpose.ScanAndImport(this.model.get('task').form_hash);
        if ((_ref = this.storedForm) != null ? _ref.isSiteImport() : void 0) {
          this._restoreSiteImport();
          this._restoreLayout();
        }
        if ((_ref1 = this.storedForm) != null ? _ref1.isScanAndImport() : void 0) {
          this._restoreScanAndImport();
          return this._restoreLayout();
        }
      };

      NexposeTask.prototype.showClonedTask = function() {
        var _ref, _ref1;
        this.controller = new Pro.ImportsApp.Index.Controller({
          type: Pro.ImportsApp.Index.Type.Nexpose,
          showTypeSelection: false,
          region: this.configRegion
        });
        this._initErrorMessages();
        this.storedForm = this.model.get('clonedModel');
        if ((_ref = this.storedForm) != null ? _ref.isSiteImport() : void 0) {
          this._restoreSiteImport();
          this._restoreLayout();
        }
        if ((_ref1 = this.storedForm) != null ? _ref1.isScanAndImport() : void 0) {
          this._restoreScanAndImport();
          this._restoreLayout();
        }
        return this.model.set('cloned', null);
      };

      NexposeTask.prototype.showCachedExistingTask = function() {
        var _ref;
        this.controller = new Pro.ImportsApp.Index.Controller({
          type: Pro.ImportsApp.Index.Type.Nexpose,
          showTypeSelection: false,
          region: this.configRegion
        });
        if ((_ref = this.storedForm) != null ? _ref.isSiteImport() : void 0) {
          this._restoreSiteImport();
          this._restoreLayout();
        } else {
          this._restoreScanAndImport();
          this._restoreLayout();
        }
        return this._initErrorMessages();
      };

      NexposeTask.prototype._restoreLayout = function() {
        var _ref,
          _this = this;
        if (this.storedForm) {
          this.controller._mainView.ui.autoTagOs.prop('checked', this.storedForm.get('autotag_os') === true || this.storedForm.get('autotag_os') === 'true');
          this.controller._mainView.ui.preserveHosts.prop('checked', this.storedForm.get('preserve_hosts') === true || this.storedForm.get('preserve_hosts') === 'true');
          if (((_ref = this.storedForm.get('tagTokens')) != null ? _ref.length : void 0) > 0) {
            this.controller.tagController.restoreTokens(this.storedForm.get('tagTokens'));
            this.controller._mainView.expandTagSection();
          }
          return this.listenTo(this.controller.tagController.tagForm, 'token:changed', function() {
            return _this._storeView();
          });
        }
      };

      NexposeTask.prototype._restoreScanAndImport = function() {
        var _this = this;
        if (this.storedForm) {
          if (this.storedForm.get('consoleId')) {
            this.controller.nexposeController._mainView.setConsole(this.storedForm.get('consoleId'));
          }
          if (this.storedForm.get('consoleId')) {
            Pro.execute("loadingOverlay:show");
          }
          this.controller.nexposeController._mainView.setScanAndImport();
          return this.listenTo(this.controller.nexposeController, 'scanAndImport:rendered', function() {
            var _ref;
            _this._initErrorMessages();
            Pro.execute("loadingOverlay:hide");
            _this.controller.nexposeController.scanAndImport.ui.whitelistHosts.val(_this.storedForm.get('whitelist_string'));
            _this.controller.nexposeController.scanAndImport.ui.blacklistHosts.val(_this.storedForm.get('blacklist_string'));
            _this.controller.nexposeController.scanAndImport.ui.scanTemplate.val(_this.storedForm.get('scan_template'));
            if (((_ref = _this.storedForm.get('tagTokens')) != null ? _ref.length : void 0) > 0) {
              _this.controller.tagController.restoreTokens(_this.storedForm.get('tagTokens'));
              _this.controller._mainView.expandTagSection();
            }
            return _this.trigger('loaded');
          });
        }
      };

      NexposeTask.prototype._restoreSiteImport = function() {
        if (this.storedForm) {
          this.controller.nexposeController.once('nexposeSites:initialized', this._setTable);
          if (this.storedForm.get('consoleId')) {
            this.controller.nexposeController._mainView.setConsole(this.storedForm.get('consoleId'));
          }
          this.controller.nexposeController._mainView.setSiteImport();
          if (this.storedForm.get('consoleId')) {
            return Pro.execute("loadingOverlay:show");
          }
        }
      };

      NexposeTask.prototype._setTable = function() {
        this._initErrorMessages();
        return this.controller.nexposeController.setTableSelections(this.storedForm.get('siteNames'), this.storedForm.get('tableSelections'));
      };

      NexposeTask.prototype.isExistingTask = function() {
        return (this.model.get('task') != null) && !(this.form_cache != null) && !this.model.get('task').form_hash.migrated;
      };

      NexposeTask.prototype.isCachedExistingTask = function() {
        return (this.form_cache != null) && !(this.model.get('cloned') != null);
      };

      NexposeTask.prototype.isClonedTask = function() {
        return this.model.get('cloned') != null;
      };

      NexposeTask.prototype.formModel = function() {
        return this.storedForm;
      };

      NexposeTask.prototype._initErrorMessages = function() {
        var _ref;
        if (this.errors) {
          if (typeof this.errors === 'object') {
            if (this.controller.nexposeController.isScanAndImport()) {
              return (_ref = this.controller.nexposeController.scanAndImport) != null ? _ref.showErrors(this.errors) : void 0;
            }
          } else {
            return this.controller.nexposeController._mainView.showErrors(this.errors);
          }
        }
      };

      NexposeTask.prototype._storeForm = function(opts) {
        if (opts == null) {
          opts = {
            callSuper: true
          };
        }
        if (opts.callSuper) {
          NexposeTask.__super__._storeForm.apply(this, arguments);
        }
        return this._storeView();
      };

      NexposeTask.prototype._storeView = function() {
        var table,
          _this = this;
        if (this.controller.nexposeController.isSiteImport()) {
          table = this.controller.nexposeController._mainView.nexposeSitesRegion.currentView.table;
          if (table) {
            table.collection.fetchIDs(this.controller.nexposeController._mainView.nexposeSitesRegion.currentView.table.tableSelections, {
              ignore_if_no_selections: ''
            }).done(function(ids) {
              _this.storedForm = _this.controller.getSiteImportEntity(ids);
              _this.storedForm.set('consoleId', parseInt(_this.controller.nexposeController._mainView.ui.nexposeConsole.val()));
              _this.storedForm.set('tableSelections', _this.controller.nexposeController._mainView.nexposeSitesRegion.currentView.table.tableSelections);
              _this.storedForm.set('siteNames', _this._getTableSiteNames());
              _this.storedForm.set({
                tagTokens: _this.controller.tagController.getTokens()
              });
              return _this._validate();
            });
          } else {
            this.storedForm = this.controller.getSiteImportEntity();
            this.storedForm.set({
              tagTokens: this.controller.tagController.getTokens()
            });
          }
        }
        if (this.controller.nexposeController.isScanAndImport()) {
          this.storedForm = this.controller.getScanAndImportEntity();
          this.storedForm.set('consoleId', parseInt(this.controller.nexposeController._mainView.ui.nexposeConsole.val()));
          this.storedForm.set({
            tagTokens: this.controller.tagController.getTokens()
          });
        }
        return this.storedForm;
      };

      NexposeTask.prototype._getTableSiteNames = function() {
        var $el, siteNames,
          _this = this;
        $el = this.controller.nexposeController._mainView.nexposeSitesRegion.currentView.table._mainView.$el;
        siteNames = [];
        _.each($('tr td input:checked', $el), function(elem) {
          var siteName;
          siteName = $('td.name span', $(elem).closest('tr')).html();
          return siteNames.push(siteName);
        });
        return siteNames;
      };

      NexposeTask.prototype._setCache = function() {
        return NexposeTask.__super__._setCache.apply(this, arguments);
      };

      NexposeTask.prototype.onBeforeClose = function() {
        NexposeTask.__super__.onBeforeClose.apply(this, arguments);
        if (!(this.controller.nexposeController.isSiteImport() && (this.controller.nexposeController._mainView.nexposeSitesRegion.currentView.table != null))) {
          return this._validate();
        }
      };

      NexposeTask.prototype._triggerValidated = function(model, response, options) {
        var _ref;
        if (response.errors) {
          this.errors = response.errors;
          $(document).trigger('showErrorPie', this);
        } else {
          this.errors = null;
        }
        if ((_ref = response.responseJSON) != null ? _ref.errors : void 0) {
          $(document).trigger('showErrorPie', this);
          this.errors = response.responseJSON.errors;
        } else {
          this.errors = null;
        }
        return $(document).trigger('validated', this);
      };

      NexposeTask.prototype._validate = function() {
        $(document).trigger('before:validated', this);
        if (this.controller.nexposeController.importRun == null) {
          this.errors = "Must Select a Nexpose Console";
          $(document).trigger('showErrorPie', this);
          $(document).trigger('validated', this);
          this._setCache();
          this._storeForm();
        } else {
          if (this.storedForm != null) {
            this.controller.validate(this._triggerValidated, this.storedForm);
          }
        }
        return this.bindUIElements();
      };

      return NexposeTask;

    })(TaskConfigView);
  });

}).call(this);
