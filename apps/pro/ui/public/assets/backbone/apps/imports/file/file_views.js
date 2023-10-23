(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_layout', 'base_view', 'base_itemview', 'apps/imports/file/templates/file_layout'], function() {
    return this.Pro.module('ImportsApp.File', function(File, App, Backbone, Marionette, $, _) {
      return File.Layout = (function(_super) {

        __extends(Layout, _super);

        function Layout() {
          return Layout.__super__.constructor.apply(this, arguments);
        }

        Layout.prototype.template = Layout.prototype.templatePath('imports/file/file_layout');

        Layout.prototype.ui = {
          blacklistHosts: '#nexpose_scan_task_blacklist_string',
          errors: '.error-container',
          useLastUploaded: '[name="use_last_uploaded"]',
          lastUploaded: '.last-uploaded'
        };

        Layout.prototype.regions = {
          fileInputRegion: '.file-input-region'
        };

        Layout.prototype.showErrors = function(errors) {
          this.ui.errors.css('display', 'block');
          this.ui.errors.addClass('errors');
          return this.ui.errors.html(_.escape(errors));
        };

        Layout.prototype.clearErrors = function() {
          this.ui.errors.removeClass('errors');
          return this.ui.errors.html();
        };

        Layout.prototype.clearLastUploaded = function() {
          this.lastUploaded = null;
          this.ui.lastUploaded.hide();
          return this.ui.useLastUploaded.val('');
        };

        Layout.prototype.useLastUploaded = function(fileName) {
          this.lastUploaded = fileName;
          this.ui.lastUploaded.show();
          this.ui.lastUploaded.text("Last Uploaded: " + fileName);
          return this.ui.useLastUploaded.val(fileName);
        };

        return Layout;

      })(App.Views.Layout);
    });
  });

}).call(this);
