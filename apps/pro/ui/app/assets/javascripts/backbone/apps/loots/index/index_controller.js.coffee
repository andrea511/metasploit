define [
  'base_controller'
  'lib/components/analysis_tab/analysis_tab_controller'
  'apps/loots/index/index_views'
  'entities/loot'
  'css!css/components/pill'
], ->
  @Pro.module "LootsApp.Index", (Index, App, Backbone, Marionette, $, _) ->
    class Index.Controller extends App.Controllers.Application

      # Create a new instance of the IndexController and adds it to the region if show is true
      #
      # @param opts [Object] the options hash
      # @options options show        [Boolean] show view on initialization
      #
      initialize: (options) ->
        _.defaults options,
          show: true

        { show } = options

        loots = App.request 'loots:entities', index: true, fetch: false

        defaultSort = 'created_at'

        columns = [
          {
            attribute: 'host.name'
            label:     'Host Name'
            escape:    false
            sortable:  true
          }
          {
            label:     'Type'
            attribute: 'ltype'
          }
          {
            attribute: 'name'
          }
          {
            attribute: 'size'
            sortable:  false
          }
          {
            attribute: 'info'
          }
          {
            attribute: 'data'
            view:      Index.DataCellView
            sortable:  false
          }
          {
            label:     'Created'
            attribute: 'created_at'
            defaultDirection: 'desc'
          }
        ]
        actionButtons = [
          {
            label: 'Delete Captured Data'
            class: 'delete'
            activateOn: 'any'
            click: (selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) ->
              controller = App.request 'loots:delete',
                {
                  selectAllState
                  selectedIDs
                  deselectedIDs
                  selectedVisibleCollection
                  tableCollection
                }
              App.execute "showModal", controller,
                modal:
                  title: 'Are you sure?'
                  description: ''
                  height: 150
                  width:  550
                  hideBorder:true
                buttons: [
                  { name: 'Cancel', class: 'close' }
                  { name: 'OK', class: 'btn primary' }
                ]
            containerClass: 'action-button-right-separator'
          }
          {
            label: 'Scan'
            class: 'scan'
            click: (selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) ->
              newScanPath = Routes.new_scan_path workspace_id: WORKSPACE_ID
              App.execute 'analysis_tab:post', 'loot', newScanPath, {
                selectAllState
                selectedIDs
                deselectedIDs
              }
          }
          {
            label: 'Import...'
            class: 'import'
            click: ->
              window.location = Routes.new_workspace_import_path(workspace_id: WORKSPACE_ID) + '#file'
          }
          {
            label: 'Nexpose Scan'
            class: 'nexpose'
            click: ->
              window.location = Routes.new_workspace_import_path workspace_id: WORKSPACE_ID
          }
          {
            label: 'WebScan'
            class: 'webscan'
            click: (selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) ->
              newWebScanPath = Routes.new_webscan_path workspace_id: WORKSPACE_ID
              App.execute 'analysis_tab:post', 'loot', newWebScanPath, {
                selectAllState
                selectedIDs
                deselectedIDs
              }
          }
          {
            label: 'Modules'
            class: 'exploit'
            click: (selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) =>
              modulesPath = Routes.modules_path workspace_id: WORKSPACE_ID
              App.execute 'analysis_tab:post', 'loot', modulesPath, {
                selectAllState
                selectedIDs
                deselectedIDs
              }
            containerClass: 'action-button-separator'
          }
          {
            label: 'Bruteforce'
            class: 'brute'
            click: (selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) ->
              newQuickBruteforcePath = Routes.workspace_brute_force_guess_index_path(workspace_id: WORKSPACE_ID) + '#quick'
              App.execute 'analysis_tab:post', 'loot', newQuickBruteforcePath, {
                selectAllState
                selectedIDs
                deselectedIDs
              }
          }
          {
            label: 'Exploit'
            class: 'exploit'
            click: (selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) ->
              newExploitPath = Routes.new_exploit_path(workspace_id: WORKSPACE_ID) + '#quick'
              App.execute 'analysis_tab:post', 'loot', newExploitPath, {
                selectAllState
                selectedIDs
                deselectedIDs
              }
          }

        ]

        filterOpts =
          searchType: 'pro'
          placeHolderText: 'Search Evidence'

        emptyView = App.request 'analysis_tab:empty_view',
          emptyText: "No captured data is associated with this project"

        _.extend options,
          collection:    loots
          columns:       columns
          defaultSort:   defaultSort
          actionButtons: actionButtons
          filterOpts:    filterOpts
          emptyView:     emptyView

        @analysisTabController = App.request('analysis_tab:component', options)
        @layout = @analysisTabController.layout

        @setMainView @layout

        @show @layout, region: @region if show
