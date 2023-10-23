define [
  'base_controller'
  'lib/components/analysis_tab/analysis_tab_controller'
  'lib/components/tags/new/new_controller'
  'entities/host'
  'apps/hosts/index/index_views'
  'css!css/components/pill'
], ->
  @Pro.module "HostsApp.Index", (Index, App, Backbone, Marionette, $, _) ->
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

        hosts = App.request 'hosts:entities', [], { workspace_id: WORKSPACE_ID, fetch: false }

        defaultSort = 'address'

        columns = [
          {
            attribute: 'address'
            escape:    false
            defaultDirection:      'asc'
          }
          {
            attribute: 'name'
            escape:    false
          }
          {
            attribute: 'os_name'
            label:     'Operating System'
            escape:    false
          }
          {
            attribute: 'virtual_host'
            view:       Index.VirtualCellView
            label:      'VM'
            escape:     false
            class:      'vm'
          }
          {
            attribute: 'purpose'
          }
          {
            attribute: 'service_count'
            label:     'Svcs'
            class:     'services'
          }
          {
            attribute: 'vuln_count'
            label:     'Vlns'
            class:     'vulns'
          }
          {
            attribute: 'exploit_attempt_count'
            label:     'Att'
            class:     'attempts'
          }
          {
            attribute: 'tags'
            sortable:  false
            escape:    false
          }
          {
            attribute: 'updated_at'
            label:     'Updated'
            escape:    false
          }
          {
            attribute: 'status'
            escape:    false
            sortable:  false
          }
        ]
        actionButtons = [
          {
            label: 'Delete Hosts'
            class: 'delete'
            activateOn: 'any'
            click: (selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) ->
              controller = App.request 'hosts:delete',
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
              url = Routes.quick_multi_tag_path WORKSPACE_ID
              controller = App.request 'tags:new:component', collection,
                {
                  selectAllState
                  selectedIDs
                  deselectedIDs
                  q: query
                  url: url
                  serverAPI: tableCollection.server_api
                  ids_only: true
                  content: 'Tag the selected hosts.'
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
                  tableCollection.fetch reset: true
            containerClass: 'action-button-right-separator'
          }
          {
            label: 'Scan'
            class: 'scan'
            click: (selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) ->
              newScanPath = Routes.new_scan_path workspace_id: WORKSPACE_ID
              App.execute 'analysis_tab:post', 'host', newScanPath, {
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
              App.execute 'analysis_tab:post', 'host', newWebScanPath, {
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
              App.execute 'analysis_tab:post', 'host', modulesPath, {
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
              App.execute 'analysis_tab:post', 'host', newQuickBruteforcePath, {
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
              App.execute 'analysis_tab:post', 'host', newExploitPath, {
                selectAllState
                selectedIDs
                deselectedIDs
              }
            containerClass: 'action-button-right-separator'
          }
          {
            label: 'New Host'
            class: 'new'
            click: ->
              window.location = Routes.new_host_path workspace_id: WORKSPACE_ID
          }
        ]

        filterOpts =
          searchType: 'pro'
          placeHolderText: 'Search Hosts'

        emptyView = App.request 'analysis_tab:empty_view',
          emptyText: "No hosts are associated with this project"

        _.extend options,
          collection:    hosts
          columns:       columns
          defaultSort:   defaultSort
          actionButtons: actionButtons
          filterOpts:    filterOpts
          emptyView:     emptyView

        @analysisTabController = App.request('analysis_tab:component', options)
        @layout = @analysisTabController.layout

        @setMainView @layout

        @show @layout, region: @region if show
