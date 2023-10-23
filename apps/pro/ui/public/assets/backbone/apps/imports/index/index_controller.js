(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'apps/imports/index/index_views', 'apps/imports/nexpose/nexpose_controller', 'apps/imports/file/file_controller', 'apps/imports/sonar/sonar_controller', 'apps/imports/index/type', 'entities/nexpose/import', 'entities/nexpose/scan_and_import', 'entities/nexpose/file_import', 'lib/components/tags/new/new_controller'], function() {
    return this.Pro.module("ImportsApp.Index", function(Index, App, Backbone, Marionette, $, _) {
      return Index.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          this._updateFileImportButton = __bind(this._updateFileImportButton, this);

          this._updateScanAndImportButton = __bind(this._updateScanAndImportButton, this);

          this._updateSiteImportButton = __bind(this._updateSiteImportButton, this);

          this._resetTags = __bind(this._resetTags, this);
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.initialize = function(options) {
          var showTypeSelection,
            _this = this;
          this.channel = Backbone.Radio.channel('imports:index');
          this.tagController = this._getTagController();
          _.defaults(options, {
            type: Index.Type.Nexpose,
            showTypeSelection: true
          });
          this.type = options.type, showTypeSelection = options.showTypeSelection;
          this.typeSelectionModel = new Index.ImportTypeSelection({
            type: this.type,
            showTypeSelection: showTypeSelection
          });
          this.typeSelectionView = new Index.TypeSelectionView({
            model: this.typeSelectionModel
          });
          this.layout = new Index.Layout({
            model: this.typeSelectionModel,
            channel: this.channel
          });
          this.setMainView(this.layout);
          this.listenTo(this._mainView, 'import:start', function() {
            var type;
            type = _this.typeSelectionModel.get('type');
            switch (type) {
              case Index.Type.File:
                return _this._launchFileImport();
              case Index.Type.Nexpose:
                if (_this.nexposeController.isSiteImport()) {
                  _this.table.collection.fetchIDs(_this.table.tableSelections).done(function(ids) {
                    return _this._launchSiteImport(ids);
                  });
                }
                if (_this.nexposeController.isScanAndImport()) {
                  return _this._launchScanAndImport();
                }
                break;
              case Index.Type.Sonar:
                return _this._launchSonarImport();
              default:
                throw "Invalid import type [" + type + "], cannot start import.";
            }
          });
          this.channel.reply('get:tags', function() {
            return _this._getTags();
          });
          this.channel.comply('enable:importButton', function() {
            return _this._mainView.enableImportButton();
          });
          this.channel.comply('disable:importButton', function() {
            return _this._mainView.disableImportButton();
          });
          this.listenTo(this.typeSelectionView, 'import:typeChange', function(model) {
            var type;
            type = model.get('type');
            App.vent.trigger('import:typeChange', type);
            _this._mainView.disableImportButton();
            _this._mainView.model.set('showAutoTagByOS', true);
            _this._mainView.model.set('showDontChangeExistingHosts', true);
            switch (type) {
              case Index.Type.File:
                return _this._showFileImport();
              case Index.Type.Nexpose:
                return _this._showNexposeImport();
              case Index.Type.Sonar:
                _this._mainView.model.set('showAutoTagByOS', false);
                _this._mainView.model.set('showDontChangeExistingHosts', false);
                return _this._showSonarImport();
              default:
                throw "Invalid import type [" + type + "]";
            }
          });
          this.listenTo(this._mainView, 'show', function() {
            if (showTypeSelection) {
              _this._showTypeSelection();
            }
            _this._showFooter();
            _this._mainView.model.set('showAutoTagByOS', true);
            _this._mainView.model.set('showDontChangeExistingHosts', true);
            switch (_this.type) {
              case Index.Type.File:
                return _this._showFileImport();
              case Index.Type.Nexpose:
                return _this._showNexposeImport();
              case Index.Type.Sonar:
                _this._mainView.model.set('showAutoTagByOS', false);
                _this._mainView.model.set('showDontChangeExistingHosts', false);
                return _this._showSonarImport();
              default:
                throw "Invalid import view type [" + _this.type + "]";
            }
          });
          return this.show(this._mainView);
        };

        Controller.prototype._showFileImport = function() {
          var _this = this;
          this._resetTags();
          this.fileController = App.request('file:imports', {});
          this.listenTo(this.fileController._mainView, 'show', function() {
            return _this.listenTo(_this.fileController.fileInput._mainView, 'file:changed', function() {
              return _this._updateFileImportButton();
            });
          });
          return this.show(this.fileController, {
            region: this._mainView.mainImportViewRegion
          });
        };

        Controller.prototype._showSonarImport = function() {
          this._resetTags(['sonar']);
          this.layout.expandTagSection();
          this.sonarController = App.request('sonar:imports', {
            importsIndexChannel: this.channel
          });
          return this.show(this.sonarController, {
            region: this._mainView.mainImportViewRegion
          });
        };

        Controller.prototype._showNexposeImport = function() {
          var nexposeImport,
            _this = this;
          this._resetTags();
          this._mainView.$el.on('site:rows:changed', this._updateSiteImportButton);
          nexposeImport = App.request('new:nexpose:import:entity', {
            consoles: gon.consoles
          });
          this.nexposeController = App.request('nexpose:imports', {
            model: nexposeImport
          });
          this.listenTo(this.nexposeController, "show:form", function() {
            return _this._mainView.disableImportButton();
          });
          this.listenTo(this.nexposeController, "scanAndImport:changed", function(whitelistHosts) {
            return _this._updateScanAndImportButton(whitelistHosts);
          });
          return this.show(this.nexposeController, {
            region: this._mainView.mainImportViewRegion
          });
        };

        Controller.prototype._showTypeSelection = function() {
          return this.show(this.typeSelectionView, {
            region: this._mainView.importTypeSelectRegion
          });
        };

        Controller.prototype._getTagController = function() {
          var collection, msg, query, url;
          msg = "<p>\n  A tag is an identifier that you can use to group together logins.\n  You apply tags so that you can easily search for logins.\n  For example, when you search for a particular tag, any login that\n  is labelled with that tag will appear in your search results.\n</p>\n<p>\n  To apply a tag, start typing the name of the tag you want to use in the\n  Tag field. As you type in the search box, Metasploit automatically predicts\n  the tags that may be similar to the ones you are searching for. If the tag\n  does not exist, Metasploit creates and adds it to the project.\n</p>";
          query = "";
          url = "";
          collection = new Backbone.Collection([]);
          return App.request('tags:new:component', collection, {
            q: query,
            url: url,
            content: msg
          });
        };

        Controller.prototype._showFooter = function() {
          return this.show(this.tagController, {
            region: this._mainView.tagsRegion
          });
        };

        Controller.prototype._resetTags = function(tags) {
          this.tagController.clearTokens();
          return this.tagController.addTokens(tags);
        };

        Controller.prototype._getTags = function() {
          var tokens;
          tokens = this.tagController.getTokens();
          return _.pluck(tokens, 'name');
        };

        Controller.prototype._launchFileImport = function() {
          var fileImport, iframeSaveOptions;
          fileImport = this.getFileImportEntity();
          iframeSaveOptions = this.iframeSaveOptions({
            fileImport: fileImport
          });
          return fileImport.save({}, iframeSaveOptions);
        };

        Controller.prototype._launchSiteImport = function(sites) {
          var scanAndImport;
          scanAndImport = this.getSiteImportEntity(sites);
          return scanAndImport.save({}, {
            success: function(model, response) {
              return window.location.replace(response.redirect_url);
            }
          });
        };

        Controller.prototype._launchScanAndImport = function() {
          var scanAndImport,
            _this = this;
          scanAndImport = this.getScanAndImportEntity();
          return scanAndImport.save({}, {
            success: function(model, response) {
              return window.location.replace(response.redirect_url);
            },
            error: function(model, response) {
              return _this.nexposeController.scanAndImport.showErrors(response.responseJSON.errors);
            }
          });
        };

        Controller.prototype._launchSonarImport = function() {
          return this.sonarController.submitImport();
        };

        Controller.prototype.validate = function(callback, model) {
          var opts,
            _this = this;
          if (model == null) {
            model = {};
          }
          opts = {
            success: function(model, response, options) {
              return typeof callback === "function" ? callback(model, response, options) : void 0;
            },
            error: function(model, response, options) {
              return typeof callback === "function" ? callback(model, response, options) : void 0;
            }
          };
          if (this.type === Index.Type.File) {
            opts = _.extend(opts, this.iframeSaveOptions({
              noFile: true,
              fileImport: model
            }));
          }
          return model.validateModel(opts);
        };

        Controller.prototype.iframeSaveOptions = function(opts) {
          var config, data, fileOpts, iframeSaveOptions,
            _this = this;
          if (opts == null) {
            opts = {};
          }
          config = _.defaults(opts, {
            noFile: false
          });
          iframeSaveOptions = {};
          if (!config.noFile) {
            data = config.fileImport.attributes;
            data.authenticity_token = $('meta[name=csrf-token]').attr('content');
            data.iframe = !config.noFile;
            fileOpts = {
              no_files: true,
              iframe: !config.noFile,
              files: this.fileController.fileInput._mainView.ui.file_input,
              data: data,
              complete: function(model, response) {
                if (response === 'error') {
                  return _this.fileController._mainView.showErrors(model.responseJSON.errors);
                } else {
                  _this.fileController._mainView.clearErrors();
                  return window.location.replace(response.redirect_url);
                }
              },
              error: function(_model, response) {
                return _this.fileController._mainView.showErrors(response.responseJSON.errors);
              }
            };
            _.extend(iframeSaveOptions, fileOpts);
          }
          return iframeSaveOptions;
        };

        Controller.prototype.getFileImportEntity = function() {
          var autotagOs, blacklist, file_path, preserveHosts;
          autotagOs = this._mainView.ui.autoTagOs.prop('checked');
          blacklist = this.fileController._mainView.ui.blacklistHosts.val();
          preserveHosts = this._mainView.ui.preserveHosts.prop('checked');
          file_path = this.fileController.fileInput._mainView.ui.file_input.val();
          return App.request('nexpose:fileImport:entity', {
            file_path: file_path,
            autotag_os: autotagOs,
            blacklist_string: blacklist,
            preserve_hosts: preserveHosts,
            tags: this.tagController.getDataOptions().new_entity_tags
          });
        };

        Controller.prototype.getSiteImportEntity = function(sites) {
          var autotagOs, preserveHosts, _ref;
          if (sites == null) {
            sites = [];
          }
          autotagOs = this._mainView.ui.autoTagOs.prop('checked');
          preserveHosts = this._mainView.ui.preserveHosts.prop('checked');
          return App.request('nexpose:scanAndImport:entity', {
            sites: sites,
            import_run_id: (_ref = this.nexposeController.importRun) != null ? _ref.get('id') : void 0,
            autotag_os: autotagOs,
            tags: this.tagController.getDataOptions().new_entity_tags,
            preserve_hosts: preserveHosts
          });
        };

        Controller.prototype.getScanAndImportEntity = function() {
          var autotagOs, blacklist, consoleId, preserveHosts, scanTemplate, whitelist, _ref, _ref1, _ref2;
          whitelist = (_ref = this.nexposeController.scanAndImport) != null ? _ref.ui.whitelistHosts.val() : void 0;
          blacklist = (_ref1 = this.nexposeController.scanAndImport) != null ? _ref1.ui.blacklistHosts.val() : void 0;
          scanTemplate = (_ref2 = this.nexposeController.scanAndImport) != null ? _ref2.ui.scanTemplate.val() : void 0;
          autotagOs = this._mainView.ui.autoTagOs.prop('checked');
          preserveHosts = this._mainView.ui.preserveHosts.prop('checked');
          consoleId = parseInt(this.nexposeController._mainView.ui.nexposeConsole.val());
          return App.request('nexpose:scanAndImport:entity', {
            scan: true,
            scan_template: scanTemplate,
            whitelist_string: whitelist,
            blacklist_string: blacklist,
            autotag_os: autotagOs,
            tags: this.tagController.getDataOptions().new_entity_tags,
            preserve_hosts: preserveHosts,
            console_id: consoleId
          });
        };

        Controller.prototype._updateSiteImportButton = function(eventObject, table) {
          this.table = table;
          if (!table.tableSelections.selectAllState) {
            if (Object.keys(table.tableSelections.selectedIDs).length > 0) {
              return this._mainView.enableImportButton();
            } else {
              return this._mainView.disableImportButton();
            }
          } else {
            return this._mainView.enableImportButton();
          }
        };

        Controller.prototype._updateScanAndImportButton = function(whitelistHosts) {
          var whitelistHostsEmpty;
          whitelistHostsEmpty = whitelistHosts.strip() === "";
          if (whitelistHostsEmpty) {
            return this._mainView.disableImportButton();
          } else {
            return this._mainView.enableImportButton();
          }
        };

        Controller.prototype._updateFileImportButton = function() {
          if (this.fileController.fileInput.isFileSet()) {
            return this._mainView.enableImportButton();
          } else {
            return this._mainView.disableImportButton();
          }
        };

        return Controller;

      })(App.Controllers.Application);
    });
  });

}).call(this);
