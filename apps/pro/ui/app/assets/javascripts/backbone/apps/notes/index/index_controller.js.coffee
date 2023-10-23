define [
  'base_controller'
  'apps/notes/notes_app'
  'apps/notes/index/index_views'
  'lib/components/analysis_tab/analysis_tab_controller'
  'apps/notes/index/index_views'
  'entities/note'
  'css!css/components/pill'
], ->
  @Pro.module "NotesApp.Index", (Index, App, Backbone, Marionette, $, _) ->
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

        notes = App.request 'notes:entities', fetch: false

        defaultSort = 'host.name'

        columns = [
          {
            attribute:             'host.name'
            label:                 'Host Name'
            escape:                false
            defaultDirection:      'asc'
          }
          {
            attribute: 'ntype'
            label:     'Type'
            escape:    false
          }
          {
            attribute: 'data'
            escape:    false
            view:      Index.DataCellView
          }
          {
            label:     'Created'
            attribute: 'created_at'
          }
          # Status/flagged calculated from critcal attribute
          # so this enables reasonable sorting on this column
          {
            attribute: 'critical'
            label:     'Status'
            view:      Index.StatusCellView
          }
        ]
        actionButtons = [
          {
            label: 'Delete Notes'
            class: 'delete'
            activateOn: 'any'
            click: (selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) ->
              controller = App.request 'notes:delete',
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
              App.execute 'analysis_tab:post', 'note', newScanPath, {
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
              App.execute 'analysis_tab:post', 'note', newWebScanPath, {
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
              App.execute 'analysis_tab:post', 'note', modulesPath, {
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
              App.execute 'analysis_tab:post', 'note', newQuickBruteforcePath, {
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
              App.execute 'analysis_tab:post', 'note', newExploitPath, {
                selectAllState
                selectedIDs
                deselectedIDs
              }
          }

        ]

        filterOpts =
          searchType: 'pro'
          placeHolderText: 'Search Notes'

        emptyView = App.request 'analysis_tab:empty_view',
          emptyText: "No notes are associated with this project"

        _.extend options,
          collection:    notes
          columns:       columns
          defaultSort:   defaultSort
          actionButtons: actionButtons
          filterOpts:    filterOpts
          emptyView:     emptyView

        @analysisTabController = App.request('analysis_tab:component', options)
        @layout = @analysisTabController.layout

        @setMainView @layout

        @show @layout, region: @region if show
