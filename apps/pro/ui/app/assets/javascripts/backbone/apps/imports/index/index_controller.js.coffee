define [
  'base_controller',
  'apps/imports/index/index_views'
  'apps/imports/nexpose/nexpose_controller'
  'apps/imports/file/file_controller'
  'apps/imports/sonar/sonar_controller'
  'apps/imports/index/type'
  'entities/nexpose/import'
  'entities/nexpose/scan_and_import'
  'entities/nexpose/file_import'
  'lib/components/tags/new/new_controller'
], ->
  @Pro.module "ImportsApp.Index", (Index, App,Backbone, Marionette, $, _) ->

    class Index.Controller extends App.Controllers.Application

      initialize: (options)->

        @channel = Backbone.Radio.channel('imports:index')

        @tagController = @_getTagController()

        _.defaults options,
          type: Index.Type.Nexpose
          showTypeSelection: true

        {@type, showTypeSelection} = options

        @typeSelectionModel = new Index.ImportTypeSelection
          type: @type
          showTypeSelection: showTypeSelection

        @typeSelectionView = new Index.TypeSelectionView(model: @typeSelectionModel)

        @layout = new Index.Layout(model: @typeSelectionModel, channel: @channel)
        @setMainView(@layout)

        @listenTo @_mainView, 'import:start', =>
          type = @typeSelectionModel.get('type')
          switch type
            when Index.Type.File
              @_launchFileImport()
            when Index.Type.Nexpose
              if @nexposeController.isSiteImport()
                @table.collection.fetchIDs(@table.tableSelections)
                .done (ids) =>
                  @_launchSiteImport(ids)

              if @nexposeController.isScanAndImport()
                @_launchScanAndImport()
            when Index.Type.Sonar
              @_launchSonarImport()
            else
              throw "Invalid import type [#{type}], cannot start import."

        #
        # ImportsApp.Index.Controller channel/radio handlers
        #

        # @return [Array<String>] collection of tag names
        @channel.reply 'get:tags', =>
          @_getTags()

        # @return [Void]
        @channel.comply 'enable:importButton', =>
          @_mainView.enableImportButton()

        # @return [Void]
        @channel.comply 'disable:importButton', =>
          @_mainView.disableImportButton()

        @listenTo @typeSelectionView, 'import:typeChange', (model) =>
          type = model.get('type')
          App.vent.trigger 'import:typeChange', type
          @_mainView.disableImportButton()
          @_mainView.model.set('showAutoTagByOS', true)
          @_mainView.model.set('showDontChangeExistingHosts',true)
          switch type
            when Index.Type.File
              @_showFileImport()
            when Index.Type.Nexpose
              # TODO: rename this to nexposeImport
              @_showNexposeImport()
            when Index.Type.Sonar
              @_mainView.model.set('showAutoTagByOS', false)
              @_mainView.model.set('showDontChangeExistingHosts',false)
              @_showSonarImport()
            else
              throw "Invalid import type [#{type}]"

        @listenTo @_mainView, 'show', =>
          @_showTypeSelection() if showTypeSelection
          @_showFooter()
          @_mainView.model.set('showAutoTagByOS', true)
          @_mainView.model.set('showDontChangeExistingHosts',true)
          switch @type
            when Index.Type.File
             @_showFileImport()
            when Index.Type.Nexpose
              @_showNexposeImport()
            when Index.Type.Sonar
              @_mainView.model.set('showAutoTagByOS', false)
              @_mainView.model.set('showDontChangeExistingHosts',false)
              @_showSonarImport()
            else
              throw "Invalid import view type [#{@type}]"

        @show @_mainView

      _showFileImport: () ->
        @_resetTags()
        @fileController = App.request 'file:imports', {}

        @listenTo @fileController._mainView, 'show', =>
          @listenTo @fileController.fileInput._mainView, 'file:changed', =>
            @_updateFileImportButton()

        @show @fileController, region: @_mainView.mainImportViewRegion

      _showSonarImport: ->
        @_resetTags ['sonar']
        @layout.expandTagSection()
        @sonarController = App.request 'sonar:imports', { importsIndexChannel: @channel }
        @show @sonarController, region: @_mainView.mainImportViewRegion

      _showNexposeImport: () ->
        @_resetTags()
        @_mainView.$el.on('site:rows:changed', @_updateSiteImportButton)

        nexposeImport = App.request 'new:nexpose:import:entity', {consoles: gon.consoles}
        @nexposeController = App.request 'nexpose:imports', {model:nexposeImport}

        @listenTo @nexposeController, "show:form", =>
          @_mainView.disableImportButton()

        @listenTo @nexposeController, "scanAndImport:changed", (whitelistHosts) =>
          @_updateScanAndImportButton(whitelistHosts)


        @show @nexposeController, region: @_mainView.mainImportViewRegion

      _showTypeSelection: ->
        @show @typeSelectionView, region: @_mainView.importTypeSelectRegion

      _getTagController: ->
        msg = """
              <p>
                A tag is an identifier that you can use to group together logins.
                You apply tags so that you can easily search for logins.
                For example, when you search for a particular tag, any login that
                is labelled with that tag will appear in your search results.
              </p>
              <p>
                To apply a tag, start typing the name of the tag you want to use in the
                Tag field. As you type in the search box, Metasploit automatically predicts
                the tags that may be similar to the ones you are searching for. If the tag
                does not exist, Metasploit creates and adds it to the project.
              </p>
            """

        #TODO: Clean up and not pass in blank options
        #Don't need URl since we are saving tags through a single AJAX request
        query = ""
        url = ""

        collection = new Backbone.Collection([])
        App.request 'tags:new:component', collection, {q: query, url: url, content:msg}

      _showFooter:() ->
        @show @tagController, region: @_mainView.tagsRegion

      _resetTags: (tags) =>
        @tagController.clearTokens()
        @tagController.addTokens tags

      #
      # @return [Array<String>] collection of tag names
      #
      _getTags: ->
        tokens = @tagController.getTokens()
        _.pluck(tokens, 'name')

      _launchFileImport: () ->
        fileImport = @getFileImportEntity()
        iframeSaveOptions = @iframeSaveOptions(fileImport:fileImport)
        fileImport.save {}, iframeSaveOptions


      _launchSiteImport: (sites) ->
        scanAndImport = @getSiteImportEntity(sites)
        scanAndImport.save({},
          success:
            (model,response) ->
              window.location.replace(response.redirect_url)
        )

      _launchScanAndImport: ->
        scanAndImport = @getScanAndImportEntity()

        scanAndImport.save({},
          success:
            (model,response) ->
              window.location.replace(response.redirect_url)
          error:
            (model,response) =>
              @nexposeController.scanAndImport.showErrors(response.responseJSON.errors)
        )

      _launchSonarImport: ->
        @sonarController.submitImport()

      validate:(callback,model={}) ->
        opts = {
          success: (model,response,options) =>
            callback?(model,response,options)
          error: (model,response,options) =>
            callback?(model,response,options)
        }

        opts = _.extend(
          opts,@iframeSaveOptions(noFile:true, fileImport:model)
        ) if @type == Index.Type.File


        model.validateModel(
          opts
        )

      iframeSaveOptions: (opts={}) ->
        config = _.defaults(opts,{
          noFile:false
        })

        iframeSaveOptions = {}

        unless config.noFile
          #Add CSRF Token
          data = config.fileImport.attributes
          data.authenticity_token = $('meta[name=csrf-token]').attr('content')
          data.iframe = !config.noFile

          fileOpts =
            no_files: true
            iframe: !config.noFile
            files: @fileController.fileInput._mainView.ui.file_input
            data:   data
            complete:
              (model,response) =>
                if response == 'error'
                  @fileController._mainView.showErrors(model.responseJSON.errors)
                else
                  @fileController._mainView.clearErrors()
                  window.location.replace(response.redirect_url)
            error:
              (_model,response) =>
                @fileController._mainView.showErrors(response.responseJSON.errors)

          _.extend(iframeSaveOptions,fileOpts)

        iframeSaveOptions


      getFileImportEntity: ->
        autotagOs =  @_mainView.ui.autoTagOs.prop('checked')
        blacklist = @fileController._mainView.ui.blacklistHosts.val()
        preserveHosts = @_mainView.ui.preserveHosts.prop('checked')
        file_path = @fileController.fileInput._mainView.ui.file_input.val()

        App.request 'nexpose:fileImport:entity', {
          file_path: file_path
          autotag_os: autotagOs
          blacklist_string: blacklist
          preserve_hosts: preserveHosts,
          tags: @tagController.getDataOptions().new_entity_tags
        }


      getSiteImportEntity: (sites=[]) ->
        autotagOs =  @_mainView.ui.autoTagOs.prop('checked')
        preserveHosts = @_mainView.ui.preserveHosts.prop('checked')

        App.request 'nexpose:scanAndImport:entity', {
          sites: sites
          import_run_id: @nexposeController.importRun?.get('id')
          autotag_os: autotagOs
          tags: @tagController.getDataOptions().new_entity_tags
          preserve_hosts: preserveHosts
        }



      getScanAndImportEntity: ->
        whitelist = @nexposeController.scanAndImport?.ui.whitelistHosts.val()
        blacklist = @nexposeController.scanAndImport?.ui.blacklistHosts.val()
        scanTemplate = @nexposeController.scanAndImport?.ui.scanTemplate.val()
        autotagOs = @_mainView.ui.autoTagOs.prop('checked')
        preserveHosts = @_mainView.ui.preserveHosts.prop('checked')
        consoleId = parseInt(@nexposeController._mainView.ui.nexposeConsole.val())

        App.request 'nexpose:scanAndImport:entity', {
          scan: true
          scan_template: scanTemplate
          whitelist_string: whitelist
          blacklist_string: blacklist
          autotag_os: autotagOs
          tags: @tagController.getDataOptions().new_entity_tags
          preserve_hosts: preserveHosts
          console_id: consoleId
        }

      _updateSiteImportButton: (eventObject,table) =>
        @table = table
        unless table.tableSelections.selectAllState
          if Object.keys(table.tableSelections.selectedIDs).length > 0
            @_mainView.enableImportButton()
          else
            @_mainView.disableImportButton()
        else
          @_mainView.enableImportButton()

      _updateScanAndImportButton: (whitelistHosts) =>
        whitelistHostsEmpty = whitelistHosts.strip() == ""
        if whitelistHostsEmpty
           @_mainView.disableImportButton()
        else
          @_mainView.enableImportButton()

      _updateFileImportButton: () =>
        if @fileController.fileInput.isFileSet()
          @_mainView.enableImportButton()
        else
          @_mainView.disableImportButton()
