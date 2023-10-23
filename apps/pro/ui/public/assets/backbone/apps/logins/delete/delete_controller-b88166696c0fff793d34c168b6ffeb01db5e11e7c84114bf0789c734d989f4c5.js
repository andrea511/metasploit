(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'apps/logins/delete/delete_view', 'lib/concerns/controllers/table_selections'], function() {
    return this.Pro.module("LoginsApp.Delete", function(Delete, App, Backbone, Marionette, $, _) {
      return Delete.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          this.onFormSubmit = __bind(this.onFormSubmit, this);
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.include('TableSelections');

        Controller.prototype.initialize = function(opts) {
          this.selectAllState = opts.selectAllState, this.selectedIDs = opts.selectedIDs, this.deselectedIDs = opts.deselectedIDs, this.selectedVisibleCollection = opts.selectedVisibleCollection, this.tableCollection = opts.tableCollection, this.credID = opts.credID;
          return this.setMainView(new Delete.Layout);
        };

        Controller.prototype.onFormSubmit = function() {
          var defer, destroyPath, formSubmit,
            _this = this;
          defer = $.Deferred();
          formSubmit = function() {};
          defer.promise(formSubmit);
          destroyPath = gon.destroy_multiple_workspace_metasploit_credential_cores_path.split('/');
          destroyPath.splice(6, 0, this.credID, "logins").shift();
          destroyPath = destroyPath.join('/');
          jQuery.ajax({
            url: destroyPath,
            type: 'DELETE',
            data: {
              selections: {
                select_all_state: this.selectAllState || null,
                selected_ids: this.selectedIDs,
                deselected_ids: this.deselectedIDs
              },
              ignore_pagination: true
            },
            success: function() {
              _this.tableCollection.removeMultiple(_this.selectedVisibleCollection.models);
              defer.resolve();
              App.vent.trigger('logins:deleted');
              return App.execute('flash:display', {
                title: "Login" + (_this.pluralizedMessage('', 's')) + "  deleted",
                message: "The login" + (_this.pluralizedMessage(' was', 's were ')) + " successfully deleted."
              });
            },
            error: function() {
              return App.execute('flash:display', {
                title: 'An error occurred',
                style: 'error',
                message: 'There was a problem deleting the selected login(s).'
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
