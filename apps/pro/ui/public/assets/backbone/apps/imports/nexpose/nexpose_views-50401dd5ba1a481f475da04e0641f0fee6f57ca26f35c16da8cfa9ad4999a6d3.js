(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_layout', 'base_view', 'base_itemview', 'apps/imports/nexpose/templates/scan_and_import_layout', 'apps/imports/nexpose/templates/site_import_layout', 'apps/imports/nexpose/templates/choose_console', 'lib/components/table/table_controller'], function() {
    return this.Pro.module('ImportsApp.Nexpose', function(Nexpose, App, Backbone, Marionette, $, _) {
      Nexpose.SiteImportLayout = (function(_super) {

        __extends(SiteImportLayout, _super);

        function SiteImportLayout() {
          this._importTypeChanged = __bind(this._importTypeChanged, this);
          return SiteImportLayout.__super__.constructor.apply(this, arguments);
        }

        SiteImportLayout.prototype.template = SiteImportLayout.prototype.templatePath('imports/nexpose/site_import_layout');

        SiteImportLayout.prototype.ui = {
          configureNexposeBtn: '.configure-nexpose',
          nexposeConsole: '[name="imports[nexpose_console]"]',
          importType: '[name="imports[nexpose][type]"]',
          importTypeSelected: '[name="imports[nexpose][type]"]:checked',
          errors: '.error-container',
          scanAndImport: '#scan-and-import',
          existing: '#existing'
        };

        SiteImportLayout.prototype.regions = {
          nexposeSitesRegion: '.nexpose-sites-region'
        };

        SiteImportLayout.prototype.events = {
          'change @ui.importType': '_importTypeChanged'
        };

        SiteImportLayout.prototype.triggers = {
          'click @ui.configureNexposeBtn': 'configureNexpose:nexpose',
          'change @ui.nexposeConsole': 'selectNexposeConsole:nexpose'
        };

        SiteImportLayout.prototype.setScanAndImport = function() {
          this.ui.scanAndImport.prop('checked', true);
          return this._importTypeChanged();
        };

        SiteImportLayout.prototype.setSiteImport = function() {
          this.ui.existing.prop('checked', true);
          return this._importTypeChanged();
        };

        SiteImportLayout.prototype.setConsole = function(consoleId) {
          this.ui.nexposeConsole.val(consoleId);
          return this.ui.nexposeConsole.trigger('change');
        };

        SiteImportLayout.prototype.showErrors = function(errors) {
          this.ui.errors.css('display', 'block');
          this.ui.errors.addClass('errors');
          return this.ui.errors.html(_.escape(errors));
        };

        SiteImportLayout.prototype._importTypeChanged = function() {
          this._bindUIElements();
          return this.trigger('selectImportType:nexpose', {
            view: this
          });
        };

        SiteImportLayout.prototype.addNexposeConsoleToDropdown = function(opts) {
          var $option, consoles;
          consoles = this.model.get('consoles');
          consoles[opts.name] = opts.id;
          this.model.set('consoles', consoles);
          $option = $('<option />', {
            value: opts.id
          }).text(opts.name);
          this.ui.nexposeConsole.append($option);
          $option.prop('selected', true);
          return this.ui.nexposeConsole.trigger('change');
        };

        return SiteImportLayout;

      })(App.Views.Layout);
      Nexpose.ScanAndImportLayout = (function(_super) {

        __extends(ScanAndImportLayout, _super);

        function ScanAndImportLayout() {
          return ScanAndImportLayout.__super__.constructor.apply(this, arguments);
        }

        ScanAndImportLayout.prototype.template = ScanAndImportLayout.prototype.templatePath('imports/nexpose/scan_and_import_layout');

        ScanAndImportLayout.prototype.ui = {
          whitelistHosts: '#nexpose_scan_task_whitelist_string',
          blacklistHosts: '#nexpose_scan_task_blacklist_string',
          scanTemplate: '#nexpose_scan_task_scan_template',
          error: '.error'
        };

        ScanAndImportLayout.prototype.events = {
          'keyup @ui.whitelistHosts': '_triggerWhiteListChange'
        };

        ScanAndImportLayout.prototype.onShow = function() {
          return this._triggerWhiteListChange();
        };

        ScanAndImportLayout.prototype._triggerWhiteListChange = function(e) {
          return this.trigger('scanAndImport:changed', this.ui.whitelistHosts.val());
        };

        ScanAndImportLayout.prototype.showErrors = function(errors) {
          var _this = this;
          this.bindUIElements();
          this.ui.error.remove();
          if (errors != null) {
            return _.each(errors, function(v, k) {
              var $msg, error, name, _i, _len, _results;
              _results = [];
              for (_i = 0, _len = v.length; _i < _len; _i++) {
                error = v[_i];
                name = "nexpose_scan_task[" + k + "]";
                $msg = $('<div />', {
                  "class": 'error'
                }).text(error);
                _results.push($("[name='" + name + "']", _this.el).addClass('invalid').after($msg));
              }
              return _results;
            });
          }
        };

        return ScanAndImportLayout;

      })(App.Views.Layout);
      return Nexpose.ChooseConsole = (function(_super) {

        __extends(ChooseConsole, _super);

        function ChooseConsole() {
          return ChooseConsole.__super__.constructor.apply(this, arguments);
        }

        ChooseConsole.prototype.template = ChooseConsole.prototype.templatePath('imports/nexpose/choose_console');

        ChooseConsole.prototype.className = 'shared nexpose-sites';

        return ChooseConsole;

      })(App.Views.Layout);
    });
  });

}).call(this);
