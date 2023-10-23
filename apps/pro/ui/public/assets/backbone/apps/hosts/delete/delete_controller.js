(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'apps/hosts/delete/delete_view', 'lib/concerns/controllers/table_selections', 'lib/components/flash/flash_controller'], function() {
    return this.Pro.module("HostsApp.Delete", function(Delete, App, Backbone, Marionette, $, _) {
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
            url: Routes.destroy_multiple_hosts_path({
              workspace_id: WORKSPACE_ID
            }),
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
              _this.tableCollection.removeMultiple(_this.selectedVisibleCollection);
              defer.resolve();
              App.vent.trigger('hosts:deleted');
              return App.execute('flash:display', {
                title: "Host" + (_this.pluralizedMessage('', 's')) + " deleted",
                message: "The host" + (_this.pluralizedMessage(' was', 's were ')) + " successfully deleted."
              });
            },
            error: function() {
              return App.execute('flash:display', {
                title: 'An error occurred',
                style: 'error',
                message: "There was a problem deleting the selected host" + (_this.multipleSelected() ? 's' : void 0)
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
