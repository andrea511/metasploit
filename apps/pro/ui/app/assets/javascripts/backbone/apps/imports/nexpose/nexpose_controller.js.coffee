define [
  'base_controller',
  'apps/imports/nexpose/nexpose_views'
  'lib/components/table/table_controller'
  'lib/shared/nexpose_console/nexpose_console_controller'
  'lib/shared/nexpose_sites/nexpose_sites_controller'
  'lib/components/modal/modal_controller'
  'entities/nexpose/sites'
  'entities/nexpose/import_run'
  'lib/concerns/pollable'
], ->
  @Pro.module "ImportsApp.Nexpose", (Nexpose, App, Backbone, Marionette, $, _) ->
    class Nexpose.Controller extends App.Controllers.Application

      @include 'Pollable'

      # @property [Number] the rate (in ms) to poll for the task status
      pollInterval: 2000

      importType:
        site: 'import_site'
        scan: 'scan_and_import'

      initialize: (options)->
        @layout = new Nexpose.SiteImportLayout(model: options.model)
        @setMainView(@layout)


        @listenTo @_mainView, 'show', =>
          @chooseConsole = new Nexpose.ChooseConsole()
          @show @chooseConsole, region: @_mainView.nexposeSitesRegion

        @listenTo @_mainView, 'selectImportType:nexpose', () =>
          if @_mainView.nexposeSitesRegion.currentView != @chooseConsole
            @_showForm()

        @listenTo @_mainView, 'configureNexpose:nexpose', =>
          nexposeConsole = App.request 'nexposeConsole:shared', {}
          App.execute 'show:nexposeConsole', nexposeConsole

          @listenTo nexposeConsole, 'consoleAdded:nexposeConsole', (opts) =>
            @_mainView.addNexposeConsoleToDropdown(opts)

        @listenTo @_mainView, 'selectNexposeConsole:nexpose',(opts) =>
          consoleId = opts.view.ui.nexposeConsole.val()
          if consoleId == 'none'
            @chooseConsole = new Nexpose.ChooseConsole()
            delete @importRun
            delete @scanAndImport
            delete @nexposeSites
            @show @chooseConsole, region: @_mainView.nexposeSitesRegion
          else
            @importRun = App.request 'nexpose:importRun:entity'
            @nexpose_console_id = consoleId
            @importRun.save(nexpose_console_id: @nexpose_console_id).success(@_importRunCallback)

      _importRunCallback: =>
        App.execute "loadingOverlay:show"
        @startPolling()

      poll: =>
        if @importRun.isReadyToImport()
          @stopPolling()
          @_showForm()
        else
          @importRun.fetch()

      _showForm: ->
        @trigger('show:form')
        if @_mainView.ui.importTypeSelected.val()=='scan_and_import'
         @_showScanAndImport()
        else
         @_showSitesTable()

      _showScanAndImport: () ->
        @importRun.set('addresses',gon.addresses)
        @scanAndImport = new Nexpose.ScanAndImportLayout(model: @importRun)

        @listenTo @scanAndImport, 'scanAndImport:changed', (whitelistHosts) =>
          @trigger('scanAndImport:changed', whitelistHosts)

        @listenTo @scanAndImport, 'show', =>
          App.execute "loadingOverlay:hide"
          @trigger('scanAndImport:rendered')

        @show @scanAndImport, region: @_mainView.nexposeSitesRegion

      _showSitesTable: () ->
        collection = App.request 'nexpose:sites:entities', [],
          {nexpose_import_run_id:@importRun.get('id')}
        App.execute "loadingOverlay:hide"
        @nexposeSites = App.request 'nexposeSites:shared', {collection:collection}

        @listenTo @nexposeSites._mainView, 'table:initialized', =>
          @trigger("nexposeSites:initialized")

        @show @nexposeSites, region: @_mainView.nexposeSitesRegion

      isSiteImport: () ->
        @_mainView.ui.importTypeSelected.val()== @importType.site

      isScanAndImport: () ->
        @_mainView.ui.importTypeSelected.val()== @importType.scan

      setTableSelections: (sites,tableSelections) =>
        @listenToOnce @nexposeSites._mainView.table.tableCollection,'sync', =>
          Pro.execute "loadingOverlay:hide"
          @_setCheckboxes(sites, tableSelections)

      # Carpenter doesn't allow us to restore state :-(.
      # TODO: Add restore state capabilites to carpenter
      _setCheckboxes: (sites,tableSelections) =>
        if tableSelections.selectAllState and tableSelections.selectAllState != "false"
          $(".select-all input",@nexposeSites._mainView.$el).click()
          $(".checkbox input",@nexposeSites._mainView.$el).each(()->
            @click()
          )
          for site in sites
            $row = $("span:contains('"+site+"')", @nexposeSites._mainView.table._mainView.$el).closest('tr')
            $('td.checkbox input',$row).click()
        else
          for site in sites
            $row = $("span:contains('"+site+"')", @nexposeSites._mainView.table._mainView.$el).closest('tr')
            $('td.checkbox input',$row).click()


    # Register an Application-wide handler for rendering nexpose import controller
    App.reqres.setHandler 'nexpose:imports', (options={}) ->
      new Nexpose.Controller(options)

