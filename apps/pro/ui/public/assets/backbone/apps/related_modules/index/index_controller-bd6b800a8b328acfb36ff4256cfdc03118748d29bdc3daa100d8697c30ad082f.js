(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'apps/related_modules/related_modules_app', 'apps/related_modules/index/index_views', 'lib/components/analysis_tab/analysis_tab_controller', 'lib/components/table/table_controller', 'lib/components/pill/pill_controller', 'lib/components/stars/stars_controller', 'lib/components/os/os_controller', 'lib/components/tabs/tabs_controller', 'lib/shared/cve_cell/cve_cell_controller', 'lib/components/tags/index/index_controller', 'lib/concerns/pollable'], function() {
    return this.Pro.module("RelatedModulesApp.Index", function(Index, App, Backbone, Marionette, $, _) {
      return Index.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.initialize = function(options) {
          var actionButtons, columns, defaultSort, emptyView, filterOpts, modules, show;
          _.defaults(options, {
            show: true
          });
          show = options.show;
          modules = App.request('workspaceRelatedModules:entities', {
            workspace_id: WORKSPACE_ID
          });
          defaultSort = 'disclosure_date';
          columns = [
            {
              label: 'Platform',
              attribute: 'module_icons',
              view: Pro.Components.Os.Controller,
              sortable: false
            }, {
              label: 'Module',
              attribute: 'module',
              sortable: true,
              sortAttribute: 'name',
              view: Index.AddressCellView
            }, {
              label: 'Hosts',
              attribute: 'hosts',
              view: Index.HostAddressCellView,
              sortable: false
            }, {
              label: 'Vulnerabilities',
              attribute: 'module_vulns',
              view: Index.VulnerabilityCellView,
              sortable: false
            }, {
              label: 'References',
              attribute: 'references',
              view: Pro.Shared.CveCell.Controller,
              sortable: false
            }, {
              label: 'Disclosure',
              attribute: 'disclosure_date',
              sortable: true,
              view: Index.DateCellView
            }, {
              label: 'Ranking',
              attribute: 'rating',
              sortAttribute: 'rank',
              view: Pro.Components.Stars.Controller
            }
          ];
          actionButtons = [
            {
              label: 'Scan',
              "class": 'scan',
              click: function(selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) {
                var newScanPath;
                newScanPath = Routes.new_scan_path({
                  workspace_id: WORKSPACE_ID
                });
                return App.execute('analysis_tab:post', 'vuln', newScanPath, {
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
                return App.execute('analysis_tab:post', 'vuln', newWebScanPath, {
                  selectAllState: selectAllState,
                  selectedIDs: selectedIDs,
                  deselectedIDs: deselectedIDs
                });
              },
              containerClass: 'action-button-left-separator'
            }, {
              label: 'Bruteforce',
              "class": 'brute',
              click: function(selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) {
                var newQuickBruteforcePath;
                newQuickBruteforcePath = Routes.workspace_brute_force_guess_index_path({
                  workspace_id: WORKSPACE_ID
                }) + '#quick';
                return App.execute('analysis_tab:post', 'vuln', newQuickBruteforcePath, {
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
                return App.execute('analysis_tab:post', 'vuln', newExploitPath, {
                  selectAllState: selectAllState,
                  selectedIDs: selectedIDs,
                  deselectedIDs: deselectedIDs
                });
              },
              containerClass: 'action-button-right-separator'
            }
          ];
          filterOpts = {
            searchType: 'pro',
            placeHolderText: 'Search Modules'
          };
          emptyView = App.request('analysis_tab:empty_view', {
            emptyText: "No Modules are associated with this project"
          });
          _.extend(options, {
            filterOpts: filterOpts,
            collection: modules,
            columns: columns,
            defaultSort: defaultSort,
            actionButtons: actionButtons,
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
