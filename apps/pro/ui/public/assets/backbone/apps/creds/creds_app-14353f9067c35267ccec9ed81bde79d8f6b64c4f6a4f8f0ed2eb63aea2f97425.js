(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['apps/creds/clone/clone_controller', 'apps/creds/new/new_controller', 'apps/creds/export/export_controller', 'apps/creds/delete/delete_controller', 'lib/utilities/navigation', 'entities/cred', 'lib/components/window_slider/window_slider_controller', 'entities/origin', 'backbone_queryparams'], function(HostViewController) {
    return this.Pro.module('CredsApp', function(CredsApp, App) {
      var API,
        _this = this;
      CredsApp.Router = (function(_super) {

        __extends(Router, _super);

        function Router() {
          return Router.__super__.constructor.apply(this, arguments);
        }

        Router.prototype.appRoutes = {
          "": "index",
          "creds": "index",
          "creds/:id": "show",
          "creds/:id/hosts/:host_id": "tab",
          "creds/:id/hosts/:host_id/:tab": "tab"
        };

        return Router;

      })(Marionette.AppRouter);
      API = {
        show: function(id, cred) {
          var loading,
            _this = this;
          loading = true;
          _.delay((function() {
            if (loading) {
              return App.execute('loadingOverlay:show');
            }
          }), 50);
          return initProRequire(['apps/creds/show/show_controller'], function() {
            var showController;
            loading = false;
            App.execute('loadingOverlay:hide');
            return showController = new CredsApp.Show.Controller({
              id: id,
              cred: cred
            });
          });
        },
        tab: function(id, host_id, tab) {
          var loading,
            _this = this;
          loading = true;
          _.delay((function() {
            if (loading) {
              return App.execute('loadingOverlay:show');
            }
          }), 50);
          return initProRequire(['/assets/hosts/backbone/controllers/host_view_controller-6e6371c826a1b256cf4c95c1118e7e80f9813613e56a22c3ca34b6388c52bc1a.js'], function(HostViewController) {
            var hostController;
            loading = false;
            App.execute('loadingOverlay:hide');
            hostController = new HostViewController({
              id: host_id
            });
            return App.execute('sliderRegion:show', {
              show: true
            }, hostController.Tab, tab);
          });
        },
        index: function(params) {
          var loading,
            _this = this;
          loading = true;
          _.delay((function() {
            if (loading) {
              return App.execute('loadingOverlay:show');
            }
          }), 50);
          return initProRequire(['apps/creds/index/index_controller'], function() {
            var indexController;
            loading = false;
            App.execute('loadingOverlay:hide');
            return indexController = new CredsApp.Index.Controller({
              search: params != null ? params.search : void 0
            });
          });
        },
        "delete": function(options) {
          return new CredsApp.Delete.Controller(options);
        },
        clone: function(cred, credsCollection, $row) {
          var cloneRegion, cloneRegionName;
          cloneRegion = {};
          cloneRegionName = "cloneRegion" + cred.id;
          cloneRegion[cloneRegionName] = '#' + $row.attr('id');
          App.addRegions(cloneRegion);
          return new CredsApp.Clone.Controller({
            cred: cred.clone(),
            credsCollection: credsCollection,
            regionName: cloneRegionName
          });
        }
      };
      App.addInitializer(function() {
        return new CredsApp.Router({
          controller: API
        });
      });
      App.vent.on("host:tab:chose", function(last_tab) {
        return App.navigate("1/hosts/1/" + last_tab, {
          trigger: false
        });
      });
      App.reqres.setHandler('creds:delete', function(options) {
        if (options == null) {
          options = {};
        }
        return API["delete"](options);
      });
      App.reqres.setHandler('navigate:creds:index', function(options) {
        if (options == null) {
          options = {};
        }
        return API.index(options);
      });
      App.vent.on('clone:cred:clicked', function(model, credsCollection, row) {
        return API.clone(model, credsCollection, row);
      });
      App.addRegions({
        mainRegion: "#creds-main-region"
      });
      App.vent.on("core:tag:added", function(credsCollection) {
        App.execute('flash:display', {
          title: 'Credential(s) Tagged ',
          message: 'The credential(s) were successfully tagged.'
        });
        return credsCollection != null ? credsCollection.fetch({
          reset: true
        }) : void 0;
      });
      App.vent.on("core:tag:removed", function(credsCollection) {
        App.execute('flash:display', {
          title: 'Credential Tag Removed ',
          message: 'The tag was successfully removed.'
        });
        return credsCollection != null ? credsCollection.fetch({
          reset: true
        }) : void 0;
      });
      App.vent.on("login:tag:added", function(credsCollection) {
        App.execute('flash:display', {
          title: 'Logins(s) Tagged ',
          message: 'The login(s) were successfully tagged.'
        });
        return credsCollection.fetch({
          reset: true
        });
      });
      App.vent.on("login:added", function() {
        return Backbone.history.loadUrl(Backbone.history.fragment);
      });
      App.vent.on("cred:added", function(credsCollection) {
        App.execute('flash:display', {
          title: 'Credential created',
          message: 'The credential was successfully saved.'
        });
        return credsCollection.fetch({
          reset: true
        });
      });
      App.vent.on("creds:imported", function(credsCollection) {
        App.execute('flash:display', {
          title: 'Credentials importing',
          message: "Your credentials are importing, this may take a while. A notification will appear when done."
        });
        return credsCollection.fetch({
          reset: true
        });
      });
      return App.vent.on("cred:clicked", function(cred_id) {
        API.show(cred_id);
        return App.navigate("creds/" + cred_id, {
          trigger: false
        });
      });
    });
  });

}).call(this);
