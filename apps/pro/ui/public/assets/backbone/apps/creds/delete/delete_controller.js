(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'apps/creds/delete/delete_view', 'lib/concerns/controllers/table_selections'], function() {
    return this.Pro.module("CredsApp.Delete", function(Delete, App, Backbone, Marionette, $, _) {
      return Delete.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.include('TableSelections');

        Controller.prototype.initialize = function(opts) {
          this.selectAllState = opts.selectAllState, this.selectedIDs = opts.selectedIDs, this.deselectedIDs = opts.deselectedIDs, this.selectedVisibleCollection = opts.selectedVisibleCollection, this.tableCollection = opts.tableCollection;
          return this.setMainView(new Delete.Layout);
        };

        Controller.prototype.onFormSubmit = function() {
          var defer, formSubmit,
            _this = this;
          defer = $.Deferred();
          formSubmit = function() {};
          defer.promise(formSubmit);
          jQuery.ajax({
            url: gon.destroy_multiple_workspace_metasploit_credential_cores_path,
            type: 'DELETE',
            data: {
              selections: {
                select_all_state: this.selectAllState || null,
                selected_ids: this.selectedIDs,
                deselected_ids: this.deselectedIDs
              },
              search: this.tableCollection.server_api.search,
              ignore_pagination: true
            },
            success: function() {
              _this.tableCollection.removeMultiple(_this.selectedVisibleCollection.models);
              defer.resolve();
              App.vent.trigger('creds:deleted');
              return App.execute('flash:display', {
                title: "Credential" + (_this.pluralizedMessage('', 's')) + " deleting",
                message: "Your credentials are being deleted, this may take a while. A notification will appear when done."
              });
            }
          });
          return formSubmit;
        };

        return Controller;

      })(App.Controllers.Application);
    });
  });

}).call(this);
