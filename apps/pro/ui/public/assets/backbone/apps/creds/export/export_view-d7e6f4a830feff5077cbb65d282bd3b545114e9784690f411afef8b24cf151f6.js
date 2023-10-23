(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_view', 'base_layout', 'apps/creds/export/templates/export_layout'], function() {
    return this.Pro.module('CredsApp.Export', function(Export, App) {
      return Export.Layout = (function(_super) {

        __extends(Layout, _super);

        function Layout() {
          return Layout.__super__.constructor.apply(this, arguments);
        }

        Layout.prototype.template = Layout.prototype.templatePath('creds/export/export_layout');

        Layout.prototype.ui = {
          filenameInput: '#filename',
          csvRadioButton: '#csv',
          pwdumpRadioButton: '#pwdump',
          selectedRadioButton: '#selected',
          allRadioButton: '#all',
          formatOption: 'input[name="export_format"]',
          rowOptions: '.row-options',
          pwdumpWarning: '.pwdump-warning'
        };

        Layout.prototype.events = {
          'change @ui.formatOption': 'toggleFormatDisplay'
        };

        Layout.prototype.initialize = function(opts) {
          this.selectAllState = opts.selectAllState, this.selectedIDs = opts.selectedIDs, this.deselectedIDs = opts.deselectedIDs, this.selectedVisibleCollection = opts.selectedVisibleCollection, this.tableCollection = opts.tableCollection;
          return Layout.__super__.initialize.call(this, opts);
        };

        Layout.prototype.onShow = function() {
          this.setRowOptions();
          return this.setFilename();
        };

        Layout.prototype.setRowOptions = function() {
          var _ref;
          if (!(this.selectAllState || ((_ref = this.selectedIDs) != null ? _ref.length : void 0) > 0)) {
            this.ui.selectedRadioButton.attr('disabled', true);
            this.ui.selectedRadioButton.siblings('label').addClass('disabled');
            return this.ui.allRadioButton.prop('checked', true);
          }
        };

        Layout.prototype.setFilename = function() {
          var filename;
          filename = 'credentials-' + (new Date().getTime());
          this.ui.filenameInput.val(filename);
          return this.ui.filenameInput.select();
        };

        Layout.prototype.toggleFormatDisplay = function(e) {
          this.ui.rowOptions.toggle(!this.ui.pwdumpRadioButton.prop('checked'));
          return this.ui.pwdumpWarning.toggle(this.ui.pwdumpRadioButton.prop('checked'));
        };

        return Layout;

      })(App.Views.Layout);
    });
  });

}).call(this);
