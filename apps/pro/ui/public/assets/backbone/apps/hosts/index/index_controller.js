(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'lib/components/analysis_tab/analysis_tab_controller', 'lib/components/tags/new/new_controller', 'entities/host', 'apps/hosts/index/index_views', 'css!css/components/pill'], function() {
    return this.Pro.module("HostsApp.Index", function(Index, App, Backbone, Marionette, $, _) {
      return Index.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.initialize = function(options) {
          var actionButtons, columns, defaultSort, emptyView, filterOpts, hosts, show,
            _this = this;
          _.defaults(options, {
            show: true
          });
          show = options.show;
          hosts = App.request('hosts:entities', [], {
            workspace_id: WORKSPACE_ID,
            fetch: false
          });
          defaultSort = 'address';
          columns = [
            {
              attribute: 'address',
              escape: false,
              defaultDirection: 'asc'
            }, {
              attribute: 'name',
              escape: false
            }, {
              attribute: 'os_name',
              label: 'Operating System',
              escape: false
            }, {
              attribute: 'virtual_host',
              view: Index.VirtualCellView,
              label: 'VM',
              escape: false,
              "class": 'vm'
            }, {
              attribute: 'purpose'
            }, {
              attribute: 'service_count',
              label: 'Svcs',
              "class": 'services'
            }, {
              attribute: 'vuln_count',
              label: 'Vlns',
              "class": 'vulns'
            }, {
              attribute: 'exploit_attempt_count',
              label: 'Att',
              "class": 'attempts'
            }, {
              attribute: 'tags',
              sortable: false,
              escape: false
            }, {
              attribute: 'updated_at',
              label: 'Updated',
              escape: false
            }, {
              attribute: 'status',
              escape: false,
              sortable: false
            }
          ];
          actionButtons = [
            {
              label: 'Delete Hosts',
              "class": 'delete',
              activateOn: 'any',
              click: function(selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) {
                var controller;
                controller = App.request('hosts:delete', {
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
              },
              containerClass: 'action-button-right-separator'
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
                url = Routes.quick_multi_tag_path(WORKSPACE_ID);
                controller = App.request('tags:new:component', collection, {
                  selectAllState: selectAllState,
                  selectedIDs: selectedIDs,
                  deselectedIDs: deselectedIDs,
                  q: query,
                  url: url,
                  serverAPI: tableCollection.server_api,
                  ids_only: true,
                  content: 'Tag the selected hosts.'
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
                    App.vent.trigger('host:tag:added', tableCollection);
                    return tableCollection.fetch({
                      reset: true
                    });
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
                return App.execute('analysis_tab:post', 'host', newScanPath, {
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
                return App.execute('analysis_tab:post', 'host', newWebScanPath, {
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
                return App.execute('analysis_tab:post', 'host', modulesPath, {
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
                return App.execute('analysis_tab:post', 'host', newQuickBruteforcePath, {
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
                return App.execute('analysis_tab:post', 'host', newExploitPath, {
                  selectAllState: selectAllState,
                  selectedIDs: selectedIDs,
                  deselectedIDs: deselectedIDs
                });
              },
              containerClass: 'action-button-right-separator'
            }, {
              label: 'New Host',
              "class": 'new',
              click: function() {
                return window.location = Routes.new_host_path({
                  workspace_id: WORKSPACE_ID
                });
              }
            }
          ];
          filterOpts = {
            searchType: 'pro',
            placeHolderText: 'Search Hosts'
          };
          emptyView = App.request('analysis_tab:empty_view', {
            emptyText: "No hosts are associated with this project"
          });
          _.extend(options, {
            collection: hosts,
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
