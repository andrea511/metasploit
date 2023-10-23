define [
  'base_controller'
  'apps/services/index/index_views'
  'lib/components/analysis_tab/analysis_tab_controller'
  'entities/service'
  'entities/host'
  'lib/components/tags/new/new_controller'
  'css!css/components/pill'
], ->
  @Pro.module "ServicesApp.Index", (Index, App, Backbone, Marionette, $, _) ->
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

        services = App.request 'services:entities', index: true, fetch: false

        defaultSort = 'host.name'

        columns = [
          {
            attribute: 'host.name'
            label:     'Host Name'
            escape:    false
            defaultDirection:      'asc'
          }
          {
            attribute: 'name'
          }
          {
            attribute: 'proto'
            label:     'Protocol'
          }
          {
            attribute: 'port'
          }
          {
            attribute: 'info'
            view:      Index.InfoCellView
          }
          {
            attribute: 'state'
            view:      Index.StateCellView
            escape:    false
          }
          {
            attribute: 'updated_at'
          }
        ]
        actionButtons = [
          {
            label: 'Delete Services'
            class: 'delete'
            activateOn: 'any'
            click: (selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) ->
              controller = App.request 'services:delete',
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
          }
          {
            label: 'Tag Hosts'
            class: 'tag-edit'
            activateOn: 'any'
            click: (selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) ->
              ids = if selectAllState then deselectedIDs else selectedIDs

              # Coerce IDs into a collection of models with only id attributes
              models = _.map(ids, (id)-> new Backbone.Model({id: id}))
              collection = new Backbone.Collection(models)

              # Stub out query string for filtered tags
              query = ""
              url = Routes.quick_multi_tag_workspace_services_path WORKSPACE_ID
              controller = App.request 'tags:new:component', collection,
                {
                  selectAllState
                  selectedIDs
                  deselectedIDs
                  q: query
                  url: url
                  serverAPI: tableCollection.server_api
                  ids_only: true
                  content: 'Tag the associated hosts of the services selected.'
                }
              App.execute "showModal", controller,
                modal:
                  title: 'Tags'
                  description: ''
                  height: 170
                  width: 400
                  hideBorder: true
                buttons: [
                  {name: 'Cancel', class: 'close'}
                  {name: 'OK', class: 'btn primary'}
                ]
                doneCallback: () ->
                  App.vent.trigger 'host:tag:added', tableCollection
            containerClass: 'action-button-right-separator'
          }
          {
            label: 'Scan'
            class: 'scan'
            click: (selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) ->
              newScanPath = Routes.new_scan_path workspace_id: WORKSPACE_ID
              App.execute 'analysis_tab:post', 'service', newScanPath, {
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
              App.execute 'analysis_tab:post', 'service', newWebScanPath, {
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
              App.execute 'analysis_tab:post', 'service', modulesPath, {
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
              App.execute 'analysis_tab:post', 'service', newQuickBruteforcePath, {
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
              App.execute 'analysis_tab:post', 'service', newExploitPath, {
                selectAllState
                selectedIDs
                deselectedIDs
              }
          }
        ]

        filterOpts =
          searchType: 'pro'
          placeHolderText: 'Search Services'

        emptyView = App.request 'analysis_tab:empty_view',
          emptyText: "No services are associated with this project"

        _.extend options,
          collection:    services
          columns:       columns
          defaultSort:   defaultSort
          actionButtons: actionButtons
          filterOpts:    filterOpts
          emptyView:     emptyView

        @analysisTabController = App.request('analysis_tab:component', options)
        @layout = @analysisTabController.layout

        @setMainView @layout

        @show @layout, region: @region if show
