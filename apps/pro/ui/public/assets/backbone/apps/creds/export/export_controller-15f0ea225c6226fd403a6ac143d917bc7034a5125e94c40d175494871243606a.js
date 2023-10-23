(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'lib/components/flash/flash_controller', 'apps/creds/export/export_view'], function() {
    return this.Pro.module("CredsApp.Export", function(Export, App, Backbone, Marionette, $, _) {
      Export.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.initialize = function(opts) {
          this.selectAllState = opts.selectAllState, this.selectedIDs = opts.selectedIDs, this.deselectedIDs = opts.deselectedIDs, this.selectedVisibleCollection = opts.selectedVisibleCollection, this.tableCollection = opts.tableCollection;
          return this.setMainView(new Export.Layout(opts));
        };

        Controller.prototype.onFormSubmit = function() {
          var data, defer, formSubmit, inputs, requestURL, selections;
          defer = $.Deferred();
          formSubmit = function() {};
          defer.promise(formSubmit);
          inputs = this._mainView.$el.find('input');
          selections = {
            selections: {
              select_all_state: this.selectAllState || null,
              selected_ids: this.selectedIDs,
              deselected_ids: this.deselectedIDs
            }
          };
          data = inputs.serialize() + '&' + $.param(selections);
          requestURL = gon.export_workspace_metasploit_credential_cores_path + '?' + data;
          $('<iframe/>').attr({
            src: requestURL,
            style: 'display: none;'
          }).appendTo('body');
          defer.resolve();
          App.execute('flash:display', {
            title: 'Export requested',
            message: 'Your credentials export will begin downloading momentarily.'
          });
          return formSubmit;
        };

        return Controller;

      })(App.Controllers.Application);
      return App.reqres.setHandler('creds:export', function(options) {
        if (options == null) {
          options = {};
        }
        return new Export.Controller(options);
      });
    });
  });

}).call(this);
