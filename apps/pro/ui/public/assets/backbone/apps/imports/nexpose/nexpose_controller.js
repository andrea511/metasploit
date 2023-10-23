(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'apps/imports/nexpose/nexpose_views', 'lib/components/table/table_controller', 'lib/shared/nexpose_console/nexpose_console_controller', 'lib/shared/nexpose_sites/nexpose_sites_controller', 'lib/components/modal/modal_controller', 'entities/nexpose/sites', 'entities/nexpose/import_run', 'lib/concerns/pollable'], function() {
    return this.Pro.module("ImportsApp.Nexpose", function(Nexpose, App, Backbone, Marionette, $, _) {
      Nexpose.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          this._setCheckboxes = __bind(this._setCheckboxes, this);

          this.setTableSelections = __bind(this.setTableSelections, this);

          this.poll = __bind(this.poll, this);

          this._importRunCallback = __bind(this._importRunCallback, this);
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.include('Pollable');

        Controller.prototype.pollInterval = 2000;

        Controller.prototype.importType = {
          site: 'import_site',
          scan: 'scan_and_import'
        };

        Controller.prototype.initialize = function(options) {
          var _this = this;
          this.layout = new Nexpose.SiteImportLayout({
            model: options.model
          });
          this.setMainView(this.layout);
          this.listenTo(this._mainView, 'show', function() {
            _this.chooseConsole = new Nexpose.ChooseConsole();
            return _this.show(_this.chooseConsole, {
              region: _this._mainView.nexposeSitesRegion
            });
          });
          this.listenTo(this._mainView, 'selectImportType:nexpose', function() {
            if (_this._mainView.nexposeSitesRegion.currentView !== _this.chooseConsole) {
              return _this._showForm();
            }
          });
          this.listenTo(this._mainView, 'configureNexpose:nexpose', function() {
            var nexposeConsole;
            nexposeConsole = App.request('nexposeConsole:shared', {});
            App.execute('show:nexposeConsole', nexposeConsole);
            return _this.listenTo(nexposeConsole, 'consoleAdded:nexposeConsole', function(opts) {
              return _this._mainView.addNexposeConsoleToDropdown(opts);
            });
          });
          return this.listenTo(this._mainView, 'selectNexposeConsole:nexpose', function(opts) {
            var consoleId;
            consoleId = opts.view.ui.nexposeConsole.val();
            if (consoleId === 'none') {
              _this.chooseConsole = new Nexpose.ChooseConsole();
              delete _this.importRun;
              delete _this.scanAndImport;
              delete _this.nexposeSites;
              return _this.show(_this.chooseConsole, {
                region: _this._mainView.nexposeSitesRegion
              });
            } else {
              _this.importRun = App.request('nexpose:importRun:entity');
              _this.nexpose_console_id = consoleId;
              return _this.importRun.save({
                nexpose_console_id: _this.nexpose_console_id
              }).success(_this._importRunCallback);
            }
          });
        };

        Controller.prototype._importRunCallback = function() {
          App.execute("loadingOverlay:show");
          return this.startPolling();
        };

        Controller.prototype.poll = function() {
          if (this.importRun.isReadyToImport()) {
            this.stopPolling();
            return this._showForm();
          } else {
            return this.importRun.fetch();
          }
        };

        Controller.prototype._showForm = function() {
          this.trigger('show:form');
          if (this._mainView.ui.importTypeSelected.val() === 'scan_and_import') {
            return this._showScanAndImport();
          } else {
            return this._showSitesTable();
          }
        };

        Controller.prototype._showScanAndImport = function() {
          var _this = this;
          this.importRun.set('addresses', gon.addresses);
          this.scanAndImport = new Nexpose.ScanAndImportLayout({
            model: this.importRun
          });
          this.listenTo(this.scanAndImport, 'scanAndImport:changed', function(whitelistHosts) {
            return _this.trigger('scanAndImport:changed', whitelistHosts);
          });
          this.listenTo(this.scanAndImport, 'show', function() {
            App.execute("loadingOverlay:hide");
            return _this.trigger('scanAndImport:rendered');
          });
          return this.show(this.scanAndImport, {
            region: this._mainView.nexposeSitesRegion
          });
        };

        Controller.prototype._showSitesTable = function() {
          var collection,
            _this = this;
          collection = App.request('nexpose:sites:entities', [], {
            nexpose_import_run_id: this.importRun.get('id')
          });
          App.execute("loadingOverlay:hide");
          this.nexposeSites = App.request('nexposeSites:shared', {
            collection: collection
          });
          this.listenTo(this.nexposeSites._mainView, 'table:initialized', function() {
            return _this.trigger("nexposeSites:initialized");
          });
          return this.show(this.nexposeSites, {
            region: this._mainView.nexposeSitesRegion
          });
        };

        Controller.prototype.isSiteImport = function() {
          return this._mainView.ui.importTypeSelected.val() === this.importType.site;
        };

        Controller.prototype.isScanAndImport = function() {
          return this._mainView.ui.importTypeSelected.val() === this.importType.scan;
        };

        Controller.prototype.setTableSelections = function(sites, tableSelections) {
          var _this = this;
          return this.listenToOnce(this.nexposeSites._mainView.table.tableCollection, 'sync', function() {
            Pro.execute("loadingOverlay:hide");
            return _this._setCheckboxes(sites, tableSelections);
          });
        };

        Controller.prototype._setCheckboxes = function(sites, tableSelections) {
          var $row, site, _i, _j, _len, _len1, _results, _results1;
          if (tableSelections.selectAllState && tableSelections.selectAllState !== "false") {
            $(".select-all input", this.nexposeSites._mainView.$el).click();
            $(".checkbox input", this.nexposeSites._mainView.$el).each(function() {
              return this.click();
            });
            _results = [];
            for (_i = 0, _len = sites.length; _i < _len; _i++) {
              site = sites[_i];
              $row = $("span:contains('" + site + "')", this.nexposeSites._mainView.table._mainView.$el).closest('tr');
              _results.push($('td.checkbox input', $row).click());
            }
            return _results;
          } else {
            _results1 = [];
            for (_j = 0, _len1 = sites.length; _j < _len1; _j++) {
              site = sites[_j];
              $row = $("span:contains('" + site + "')", this.nexposeSites._mainView.table._mainView.$el).closest('tr');
              _results1.push($('td.checkbox input', $row).click());
            }
            return _results1;
          }
        };

        return Controller;

      })(App.Controllers.Application);
      return App.reqres.setHandler('nexpose:imports', function(options) {
        if (options == null) {
          options = {};
        }
        return new Nexpose.Controller(options);
      });
    });
  });

}).call(this);
