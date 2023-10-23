(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'apps/vulns/vulns_app', 'css!css/components/pill', 'apps/vulns/index/index_views', 'lib/components/analysis_tab/analysis_tab_controller', 'apps/vulns/index/components/custom_note_cell/custom_note_cell_view', 'apps/vulns/index/components/push_status_cell/push_status_cell_controller'], function() {
    return this.Pro.module("VulnsApp.Index", function(Index, App, Backbone, Marionette, $, _) {
      return Index.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          this.getPushButtonViewStatus = __bind(this.getPushButtonViewStatus, this);
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.initialize = function(options) {
          var actionButtons, buttonController, columns, defaultSort, emptyView, filterOpts, show, vulns,
            _this = this;
          _.defaults(options, {
            show: true
          });
          show = options.show;
          vulns = App.request('vulns:entities', {
            fetch: false
          });
          defaultSort = 'name';
          columns = [
            {
              attribute: 'name',
              label: 'Vulnerability',
              view: Index.NameCellView,
              "class": 'truncate'
            }, {
              attribute: 'host.address',
              label: 'Address',
              view: Index.AddressCellView,
              defaultDirection: 'asc'
            }, {
              attribute: 'host.name',
              label: 'Host Name',
              escape: false
            }, {
              attribute: 'service.name',
              label: 'Service'
            }, {
              attribute: 'service.port',
              label: 'Port'
            }, {
              attribute: 'references',
              view: Pro.Shared.CveCell.Controller,
              sortable: false
            }, {
              attribute: 'status_html',
              label: 'Status',
              escape: false,
              sortable: false,
              "class": 'status truncate'
            }, {
              attribute: 'vuln.latest_nexpose_result.type',
              label: '<img class="nx-push-icon" title="Not Pushed" src="/assets/icons/nxStatus-header-e4342bb4dad4e3191f516bb82d0f92d73ba70673f968b2067703da20d46bf3df.svg" />',
              escapeLabel: false,
              sortable: false,
              "class": 'nexpose-status',
              view: Pro.Components.PushStatusCell.Controller
            }, {
              attribute: 'comment.data.comment',
              label: 'Comments',
              "class": 'comment truncate',
              view: Pro.Components.CustomNoteCell.View,
              sortable: false
            }
          ];
          actionButtons = [
            {
              label: 'Delete Vulnerabilities',
              "class": 'delete',
              activateOn: 'any',
              click: function(selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) {
                var controller;
                controller = App.request('vulns:delete', {
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
              }
            }, {
              label: 'Modules',
              "class": 'exploit',
              click: function(selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) {
                var modulesPath;
                modulesPath = Routes.modules_path({
                  workspace_id: WORKSPACE_ID
                });
                return App.execute('analysis_tab:post', 'vuln', modulesPath, {
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
          buttonController = new App.Shared.NexposePush.ButtonController;
          actionButtons.push(buttonController.getButton());
          filterOpts = {
            searchType: 'pro',
            placeHolderText: 'Search Vulns'
          };
          emptyView = App.request('analysis_tab:empty_view', {
            emptyText: "No vulnerabilities are associated with this project"
          });
          _.extend(options, {
            filterOpts: filterOpts,
            enableNexposePushButton: true,
            collection: vulns,
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

        Controller.prototype.getPushButtonViewStatus = function() {
          if (this._mainView._currentPushButtonView) {
            return this._mainView._currentPushButtonView.getStatus();
          } else {
            return false;
          }
        };

        return Controller;

      })(App.Controllers.Application);
    });
  });

}).call(this);
