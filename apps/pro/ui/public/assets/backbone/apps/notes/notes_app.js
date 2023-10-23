(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['apps/notes/index/index_controller', 'apps/notes/delete/delete_controller', 'lib/utilities/navigation'], function() {
    return this.Pro.module('NotesApp', function(NotesApp, App) {
      var API,
        _this = this;
      NotesApp.Router = (function(_super) {

        __extends(Router, _super);

        function Router() {
          return Router.__super__.constructor.apply(this, arguments);
        }

        Router.prototype.appRoutes = {
          "": "index",
          "notes": "index"
        };

        return Router;

      })(Marionette.AppRouter);
      API = {
        index: function() {
          var loading,
            _this = this;
          loading = true;
          _.delay((function() {
            if (loading) {
              return App.execute('loadingOverlay:show');
            }
          }), 50);
          return initProRequire(['apps/notes/index/index_controller'], function() {
            var indexController;
            loading = false;
            App.execute('loadingOverlay:hide');
            return indexController = new NotesApp.Index.Controller;
          });
        },
        "delete": function(options) {
          return new NotesApp.Delete.Controller(options);
        }
      };
      App.addInitializer(function() {
        return new NotesApp.Router({
          controller: API
        });
      });
      App.addRegions({
        mainRegion: "#notes-main-region"
      });
      return App.reqres.setHandler('notes:delete', function(options) {
        if (options == null) {
          options = {};
        }
        return API["delete"](options);
      });
    });
  });

}).call(this);
