(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'lib/components/analysis_tab/analysis_tab_controller', 'apps/loots/index/index_views', 'entities/loot', 'css!css/components/pill'], function() {
    return this.Pro.module("LootsApp.Index", function(Index, App, Backbone, Marionette, $, _) {
      return Index.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.initialize = function(options) {
          var actionButtons, columns, defaultSort, emptyView, filterOpts, loots, show,
            _this = this;
          _.defaults(options, {
            show: true
          });
          show = options.show;
          loots = App.request('loots:entities', {
            index: true,
            fetch: false
          });
          defaultSort = 'created_at';
          columns = [
            {
              attribute: 'host.name',
              label: 'Host Name',
              escape: false,
              sortable: true
            }, {
              label: 'Type',
              attribute: 'ltype'
            }, {
              attribute: 'name'
            }, {
              attribute: 'size',
              sortable: false
            }, {
              attribute: 'info'
            }, {
              attribute: 'data',
              view: Index.DataCellView,
              sortable: false
            }, {
              label: 'Created',
              attribute: 'created_at',
              defaultDirection: 'desc'
            }
          ];
          actionButtons = [
            {
              label: 'Delete Captured Data',
              "class": 'delete',
              activateOn: 'any',
              click: function(selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) {
                var controller;
                controller = App.request('loots:delete', {
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
              label: 'Scan',
              "class": 'scan',
              click: function(selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) {
                var newScanPath;
                newScanPath = Routes.new_scan_path({
                  workspace_id: WORKSPACE_ID
                });
                return App.execute('analysis_tab:post', 'loot', newScanPath, {
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
                return App.execute('analysis_tab:post', 'loot', newWebScanPath, {
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
                return App.execute('analysis_tab:post', 'loot', modulesPath, {
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
                return App.execute('analysis_tab:post', 'loot', newQuickBruteforcePath, {
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
                return App.execute('analysis_tab:post', 'loot', newExploitPath, {
                  selectAllState: selectAllState,
                  selectedIDs: selectedIDs,
                  deselectedIDs: deselectedIDs
                });
              }
            }
          ];
          filterOpts = {
            searchType: 'pro',
            placeHolderText: 'Search Evidence'
          };
          emptyView = App.request('analysis_tab:empty_view', {
            emptyText: "No captured data is associated with this project"
          });
          _.extend(options, {
            collection: loots,
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
