(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'apps/services/index/index_views', 'lib/components/analysis_tab/analysis_tab_controller', 'entities/service', 'entities/host', 'lib/components/tags/new/new_controller', 'css!css/components/pill'], function() {
    return this.Pro.module("ServicesApp.Index", function(Index, App, Backbone, Marionette, $, _) {
      return Index.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.initialize = function(options) {
          var actionButtons, columns, defaultSort, emptyView, filterOpts, services, show,
            _this = this;
          _.defaults(options, {
            show: true
          });
          show = options.show;
          services = App.request('services:entities', {
            index: true,
            fetch: false
          });
          defaultSort = 'host.name';
          columns = [
            {
              attribute: 'host.name',
              label: 'Host Name',
              escape: false,
              defaultDirection: 'asc'
            }, {
              attribute: 'name'
            }, {
              attribute: 'proto',
              label: 'Protocol'
            }, {
              attribute: 'port'
            }, {
              attribute: 'info',
              view: Index.InfoCellView
            }, {
              attribute: 'state',
              view: Index.StateCellView,
              escape: false
            }, {
              attribute: 'updated_at'
            }
          ];
          actionButtons = [
            {
              label: 'Delete Services',
              "class": 'delete',
              activateOn: 'any',
              click: function(selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) {
                var controller;
                controller = App.request('services:delete', {
                  selectAllState: selectAllState,
                  selectedIDs: selectedIDs,
                  deselectedIDs: deselectedIDs,
                  selectedVisibleCollection: selectedVisibleCollection,
                  tableCollection: tableCollection
                });
                return App.execute("showModal", controller, {
                  modal: {
                    title: 'Are you sure?',
                    description: '',
                    height: 150,
                    width: 550,
                    hideBorder: true
                  },
                  buttons: [
                    {
                      name: 'Cancel',
                      "class": 'close'
                    }, {
                      name: 'OK',
                      "class": 'btn primary'
                    }
                  ]
                });
              }
            }, {
              label: 'Tag Hosts',
              "class": 'tag-edit',
              activateOn: 'any',
              click: function(selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) {
                var collection, controller, ids, models, query, url;
                ids = selectAllState ? deselectedIDs : selectedIDs;
                models = _.map(ids, function(id) {
                  return new Backbone.Model({
                    id: id
                  });
                });
                collection = new Backbone.Collection(models);
                query = "";
                url = Routes.quick_multi_tag_workspace_services_path(WORKSPACE_ID);
                controller = App.request('tags:new:component', collection, {
                  selectAllState: selectAllState,
                  selectedIDs: selectedIDs,
                  deselectedIDs: deselectedIDs,
                  q: query,
                  url: url,
                  serverAPI: tableCollection.server_api,
                  ids_only: true,
                  content: 'Tag the associated hosts of the services selected.'
                });
                return App.execute("showModal", controller, {
                  modal: {
                    title: 'Tags',
                    description: '',
                    height: 170,
                    width: 400,
                    hideBorder: true
                  },
                  buttons: [
                    {
                      name: 'Cancel',
                      "class": 'close'
                    }, {
                      name: 'OK',
                      "class": 'btn primary'
                    }
                  ],
                  doneCallback: function() {
                    return App.vent.trigger('host:tag:added', tableCollection);
                  }
                });
              },
              containerClass: 'action-button-right-separator'
            }, {
              label: 'Scan',
              "class": 'scan',
              click: function(selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) {
                var newScanPath;
                newScanPath = Routes.new_scan_path({
                  workspace_id: WORKSPACE_ID
                });
                return App.execute('analysis_tab:post', 'service', newScanPath, {
                  selectAllState: selectAllState,
                  selectedIDs: selectedIDs,
                  deselectedIDs: deselectedIDs
                });
              }
            }, {
              label: 'Import...',
              "class": 'import',
              click: function() {
                return window.location = Routes.new_workspace_import_path({
                  workspace_id: WORKSPACE_ID
                }) + '#file';
              }
            }, {
              label: 'Nexpose Scan',
              "class": 'nexpose',
              click: function() {
                return window.location = Routes.new_workspace_import_path({
                  workspace_id: WORKSPACE_ID
                });
              }
            }, {
              label: 'WebScan',
              "class": 'webscan',
              click: function(selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) {
                var newWebScanPath;
                newWebScanPath = Routes.new_webscan_path({
                  workspace_id: WORKSPACE_ID
                });
                return App.execute('analysis_tab:post', 'service', newWebScanPath, {
                  selectAllState: selectAllState,
                  selectedIDs: selectedIDs,
                  deselectedIDs: deselectedIDs
                });
              }
            }, {
              label: 'Modules',
              "class": 'exploit',
              click: function(selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) {
                var modulesPath;
                modulesPath = Routes.modules_path({
                  workspace_id: WORKSPACE_ID
                });
                return App.execute('analysis_tab:post', 'service', modulesPath, {
                  selectAllState: selectAllState,
                  selectedIDs: selectedIDs,
                  deselectedIDs: deselectedIDs
                });
              },
              containerClass: 'action-button-separator'
            }, {
              label: 'Bruteforce',
              "class": 'brute',
              click: function(selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) {
                var newQuickBruteforcePath;
                newQuickBruteforcePath = Routes.workspace_brute_force_guess_index_path({
                  workspace_id: WORKSPACE_ID
                }) + '#quick';
                return App.execute('analysis_tab:post', 'service', newQuickBruteforcePath, {
                  selectAllState: selectAllState,
                  selectedIDs: selectedIDs,
                  deselectedIDs: deselectedIDs
                });
              }
            }, {
              label: 'Exploit',
              "class": 'exploit',
              click: function(selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) {
                var newExploitPath;
                newExploitPath = Routes.new_exploit_path({
                  workspace_id: WORKSPACE_ID
                }) + '#quick';
                return App.execute('analysis_tab:post', 'service', newExploitPath, {
                  selectAllState: selectAllState,
                  selectedIDs: selectedIDs,
                  deselectedIDs: deselectedIDs
                });
              }
            }
          ];
          filterOpts = {
            searchType: 'pro',
            placeHolderText: 'Search Services'
          };
          emptyView = App.request('analysis_tab:empty_view', {
            emptyText: "No services are associated with this project"
          });
          _.extend(options, {
            collection: services,
            columns: columns,
            defaultSort: defaultSort,
            actionButtons: actionButtons,
            filterOpts: filterOpts,
            emptyView: emptyView
          });
          this.analysisTabController = App.request('analysis_tab:component', options);
          this.layout = this.analysisTabController.layout;
          this.setMainView(this.layout);
          if (show) {
            return this.show(this.layout, {
              region: this.region
            });
          }
        };

        return Controller;

      })(App.Controllers.Application);
    });
  });

}).call(this);
