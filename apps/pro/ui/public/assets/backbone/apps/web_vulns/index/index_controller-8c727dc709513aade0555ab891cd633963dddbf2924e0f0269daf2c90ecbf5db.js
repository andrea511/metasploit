(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'apps/web_vulns/web_vulns_app', 'css!css/components/pill', 'apps/web_vulns/index/index_views', 'entities/web_vuln', 'lib/components/analysis_tab/analysis_tab_controller'], function() {
    return this.Pro.module("WebVulnsApp.Index", function(Index, App, Backbone, Marionette, $, _) {
      return Index.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          this.getPushButtonViewStatus = __bind(this.getPushButtonViewStatus, this);
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.initialize = function(options) {
          var actionButtons, columns, defaultSort, emptyView, filterOpts, show, webvulns,
            _this = this;
          _.defaults(options, {
            show: true
          });
          show = options.show;
          webvulns = App.request('web_vulns:entities', {
            fetch: false
          });
          defaultSort = 'risk';
          columns = [
            {
              attribute: 'risk',
              label: 'Risk',
              "class": 'truncate'
            }, {
              attribute: 'category',
              label: 'Category',
              "class": 'truncate'
            }, {
              attribute: 'name',
              label: 'Name',
              "class": 'truncate'
            }, {
              attribute: 'blame',
              label: 'Blame',
              "class": 'truncate'
            }, {
              attribute: 'host.name',
              idattribute: 'host.id',
              label: 'Host Name',
              escape: false,
              sortable: false
            }, {
              attribute: 'url',
              label: 'URL',
              escape: false,
              sortable: false
            }, {
              attribute: 'pname',
              label: 'Parameter',
              defaultDirection: 'asc'
            }, {
              attribute: 'proof',
              label: 'Proof',
              sortable: false
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
                return App.execute('analysis_tab:post', 'web_vuln', newScanPath, {
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
                return App.execute('analysis_tab:post', 'web_vuln', newWebScanPath, {
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
                return App.execute('analysis_tab:post', 'web_vuln', modulesPath, {
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
                return App.execute('analysis_tab:post', 'web_vuln', newQuickBruteforcePath, {
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
                return App.execute('analysis_tab:post', 'web_vuln', newExploitPath, {
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
            placeHolderText: 'Search Web Vulns'
          };
          emptyView = App.request('analysis_tab:empty_view', {
            emptyText: "No vulnerabilities are associated with this project"
          });
          _.extend(options, {
            filterOpts: filterOpts,
            collection: webvulns,
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
