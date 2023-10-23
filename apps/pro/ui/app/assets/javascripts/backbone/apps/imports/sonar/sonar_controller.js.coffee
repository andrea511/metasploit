define [
  'base_controller',
  'apps/imports/sonar/sonar_layout_view'
  'lib/components/table/table_controller'
  'entities/sonar/fdns'
  'entities/sonar/import_run'
  'lib/components/pro_search_filter/filter_controller'
  'lib/concerns/pollable'
  'entities/task'
], ->
  @Pro.module "ImportsApp.Sonar", (Sonar, App, Backbone, Marionette, $, _) ->
    #
    # Controller for Sonar Import Page
    #
    class Sonar.Controller extends App.Controllers.Application

      @include 'Pollable'

      # @property [Number] the rate (in ms) to poll for the task status
      pollInterval: 2000

      initialize: (options)->
        stateModel = new Sonar.StateModel(options)
        { @importsIndexChannel } = options
        @layout = new Sonar.Layout(model: stateModel, importsIndexChannel: options.importsIndexChannel)
        @setMainView(@layout)

        @listenTo @layout, 'show', ->
          #Is Sonar Enabled?
          if gon.licensed
            @domainInputView = new Sonar.DomainInputView(model: stateModel)
            @resultView      = new Sonar.EmptyResultView(model: stateModel)

            @listenTo @domainInputView, 'query:submit', (domainUrl) ->
              @_submitQuery(domainUrl)

            @show @domainInputView, region: @layout.domainInputRegion
            @show @resultView, region: @layout.resultsRegion
          else
            #Show overlay
            $('.mainContent').addDisableOverlay('MetasploitPro')

        @listenTo @layout, 'destroy', ->
          #Remove overlay
          $('.mainContent').removeDisableOverlay('MetasploitPro')

      getDomainUrl: ->
        @domainInputView.getInputText()

      getLastSeen: ->
        @domainInputView.getLastSeen()

      _submitQuery: (domainUrl) ->
        @importRun = App.request 'sonar:importRun:entity'
        @importRun.save(workspace_id: WORKSPACE_ID, domain: domainUrl, last_seen: parseInt(@getLastSeen())).success(@_importRunCallback).
          error(@_importRunErrorCallback)

      _importRunCallback: (import_run) =>
        $('.error',@el).remove()
        #TODO: Change to App request pattern
        @task = new App.Entities.Task workspace_id: WORKSPACE_ID, id: import_run.task_id
        App.execute "loadingOverlay:show", {loadMsg:"<p>This query may take up to a minute to complete. </p>" +
          "<p>Do not navigate away from this page. You will lose your results and need to run the query again.</p>"}
        @startPolling()

      _importRunErrorCallback: (response) =>
        @_renderErrors(response.responseJSON.errors)

      # Render the private cred errors
      # @param [Object] errors hash of errors
      _renderErrors: (errors) =>
        $('.error',@el).remove()
        if !_.isEmpty(errors)
          _.each errors, (v, k) =>
            for error in v
              name = "imports[sonar][#{k}]"
              $msg = $('<div />', class: 'error').text(error)
              $("[name='#{name}']", @el).addClass('invalid').after($msg)

      poll: =>
        if @task.isCompleted()
          @stopPolling()
          App.execute "loadingOverlay:hide"
          @_showFdnsTable()
        else
          @task.fetch()


      _showFdnsTable: ->
        columns = [
          {
            label: 'Hostname'
            attribute: 'hostname'
          },
          {
            label: 'Address'
            attribute: 'address'
          },
          {
            label: 'Last seen'
            attribute: 'last_seen'
          }
        ]

        collection = App.request "fdnss:entities", workspace_id: WORKSPACE_ID, import_run_id: @importRun.get('id')

        filterOpts =
          placeHolderText: 'Search Hosts'
          filterValuesEndpoint: Routes.filter_values_workspace_sonar_import_fdnss_index_path(
            WORKSPACE_ID,
            @importRun.get('id')
          )
          keys: [
            'hostname'
            'address'
          ]

        @tableController = App.request "table:component",
          region:             @layout.resultsRegion
          htmlID:             'sonar-table'
          taggable:           true
          selectable:         true
          static:             false
          filterOpts:         filterOpts
          collection:         collection
          perPage:            20
          defaultSort:        'last_seen'
          columns: columns

        @tableController.carpenterRadio.on('table:rows:selected',@_rowsSelected)
        @tableController.carpenterRadio.on('table:rows:deselected',@_rowsSelected)
        @tableController.carpenterRadio.on('table:row:selected',@_rowsSelected)
        @tableController.carpenterRadio.on('table:row:deselected',@_rowsSelected)

      _rowsSelected: =>
        unless @tableController.tableSelections.selectAllState
          if Object.keys(@tableController.tableSelections.selectedIDs).length > 0
            @importsIndexChannel.command('enable:importButton')
          else
            @importsIndexChannel.command('disable:importButton')
        else
          @importsIndexChannel.command('enable:importButton')


      submitImport: ->
        App.execute "loadingOverlay:show"

        tags = @importsIndexChannel.request('get:tags')

        data =
          import_run_id: @importRun.get('id')
          tags:         tags
          workspace_id: WORKSPACE_ID

        @tableController.postTableState(
          #Because prototype overrides the headers
          url: Routes.workspace_sonar_imports_path(workspace_id: WORKSPACE_ID) + '.json'
          data: data
          success: (data)->
            window.location.href = Routes.task_detail_path(WORKSPACE_ID, data.task_id)
          error: (data)->
            App.execute 'sonar:imports:display:error', { message: "Doge" }
        )

    # Application-wide handler for Sonar Import Controller
    App.reqres.setHandler 'sonar:imports', (options={}) ->
      new Sonar.Controller(options)

    #
    # A View model (i.e. non-persisted) representing state for the Sonar Import App
    #
    # @params [String] domainUrl - the domain url for Sonar to query, used to pre-populate input field
    #
    class Sonar.StateModel extends Backbone.Model
      defaults:
        domainUrl: ''
        disableQuery: true
