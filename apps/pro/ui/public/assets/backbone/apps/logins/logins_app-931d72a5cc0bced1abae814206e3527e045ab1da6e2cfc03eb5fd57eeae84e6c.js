(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['lib/utilities/navigation', 'apps/logins/new/new_controller', 'apps/logins/delete/delete_controller', 'lib/components/modal/modal_controller'], function() {
    return this.Pro.module('LoginsApp', function(LoginsApp, App, Backbone, Marionette, $, _, HostViewController) {
      var API;
      LoginsApp.Router = (function(_super) {

        __extends(Router, _super);

        function Router() {
          return Router.__super__.constructor.apply(this, arguments);
        }

        Router.prototype.appRoutes = {
          ":id/logins/new": "_new"
        };

        return Router;

      })(Marionette.AppRouter);
      API = {
        _new: function() {
          return App.execute("showModal", new LoginsApp.New.Controller);
        },
        "delete": function(options) {
          return new LoginsApp.Delete.Controller(options);
        }
      };
      App.addInitializer(function() {
        return new LoginsApp.Router({
          controller: API
        });
      });
      return App.reqres.setHandler('logins:delete', function(options) {
        if (options == null) {
          options = {};
        }
        return API["delete"](options);
      });
    });
  });

}).call(this);
