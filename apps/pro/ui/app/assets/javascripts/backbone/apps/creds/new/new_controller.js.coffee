define [
  'base_controller'
  'apps/creds/new/new_view'
  'apps/logins/new/new_view'
  'lib/components/tags/new/new_controller'
  'lib/components/tabs/tabs_controller'
  'lib/components/file_input/file_input_controller'
  'entities/service'
], ->
  @Pro.module "CredsApp.New", (New, App, Backbone, Marionette, $, _) ->
    class New.Controller extends App.Controllers.Application

      # Create new instance of the Cred Form
      #
      # @param [Object] opts the options hash
      # @option opts [Array<Entities.AjaxPaginatedCollection>, Array<Entities.StaticPaginatedCollection>]
      #   :tableCollection the collection currently managed by the table
      initialize: (opts = {}) ->
        @model = App.request "new:cred:entity"
        @tableCollection = opts.tableCollection

        @setMainView(new New.Layout(model: @model))

        @listenTo @getMainView(), 'type:selected', (obj) =>
          {collection, model, view} = obj

          if $(':checked',view.ui.cred_type).val() == "import"
            @showImportCred()
          else
            @showManualCred()

        # When form container is rendered
        @listenTo @getMainView(), "show", =>
          @showManualCred()
          @showTagging()
          @hideTypes?()

      # Show Tagging Component
      showTagging: ->
        msg = App.request('new:cred:entity').get('taggingModalHelpContent')

        query = ""
        url = @model.tagUrl()

        collection = new Backbone.Collection([])
        @tagController = App.request 'tags:new:component', collection, {q: query, url: url, content:msg}
        @show @tagController, region: @_mainView.tags

      # Show Import Cred View selected from radio
      showImportCred: ->
        @importView = new New.Import(model: @model)

        @listenTo @importView, 'show', =>
          importFile = App.request 'file_input:component'
          usernameImportFile = App.request 'file_input:component', {name: 'file_input[username]', id: 'username'}
          passwordImportFile = App.request 'file_input:component', {name: 'file_input[password]', id: 'password'}
          @show importFile, region: @importView.fileInput
          @show usernameImportFile, region: @importView.userFileInput
          @show passwordImportFile, region: @importView.passFileInput

        @show @importView, region: @_mainView.formContainer

      #Show Manual Cred View selected from radio
      showManualCred: ->
        # Create instance of tagging and tabs component
        @tabController = App.request 'tabs:component', @getTabConfig(@model)

        # Show tagging and tabs component
        @show @tabController, region: @_mainView.formContainer


      # Config has for tab component
      # @param [Backbone.Model] model cred core backbone model
      # @return [Object] config hash for tab component
      getTabConfig: () ->
        tabs:[
          {name: 'Realm', view: New.Realm, model: @model}
          {name: 'Public', view: New.Public, model: @model }
          {name: 'Private', view: New.Private, model: @model}
        ]




      # "Interface" Method required by Modal Component
      onFormSubmit: () ->
        # jQuery Deferred Object that closes modal when resolved.
        defer = $.Deferred()
        formSubmit = () ->
        defer.promise(formSubmit)

        @model.set('tags', @tagController.getDataOptions())
        @model.unset('errors')

        credType = $(':checked', @_mainView.ui.cred_type).val()
        usingFileInput = @importView? and @importView.fileInput?

        # Create base save options.
        saveOptions = complete: (data) =>

          parsedData = data.responseJSON
          if parsedData.success
            # close the modal
            defer.resolve()

            if usingFileInput
              App.vent.trigger 'creds:imported', @tableCollection
            else
              App.vent.trigger 'cred:added', @tableCollection

          else
            errors = parsedData.error

            # Interpret any errors with the file as an error for the file input field.
            if parsedData.error.input
              _.extend( errors, file_input: { data: parsedData.error.input.first() } )

            @model.set 'errors', errors

            # If we're using the Add Cred modal, mark which tabs are in error.
            unless usingFileInput
              #Show Errors on Tab Component by setting errors on model
              @tabController.resetValidTabs()

              error_tabs = []

              for error, index in errors
                if _.size(error[Object.keys(error)[0]]) > 0
                  error_tabs.push(index - 1)

              # Mark tabs with errors
              @tabController.setInvalidTabs(error_tabs)

        # Build additional options needed when using file input iframe transport.
        if usingFileInput
          fileType = $(':checked', @importView.ui.importType).val()

          #Add CSRF Token
          data = @model.attributes
          data.authenticity_token = $('meta[name=csrf-token]').attr('content')
          data.cred_type = credType
          data.iframe = true

          if fileType == 'csv' || fileType == 'pwdump'
            iframeSaveOptions =
              iframe: true
              data:   data
              files: @importView.fileInput.currentView.ui.file_input
          else
            iframeSaveOptions =
              iframe: true
              data:   data
              files: $(".user-pass-file-input-region").find("input")

          _.extend(saveOptions, iframeSaveOptions)

        @model.save _.extend(@model.attributes, cred_type: credType), saveOptions

        formSubmit

    class New.LoginController extends New.Controller
      hideTypes: () ->
        @_mainView.hideCredTypes()

      #Show Manual Cred View
      showManualCred: ->
        # Create instance of tagging and tabs component
        @tabController = App.request 'tabs:component', @getTabConfig(@model)

        # Layout containing login form
        @loginLayout = new App.LoginsApp.New.Layout()

        #When Login Layout shown
        @listenTo @loginLayout, 'show', () =>
          @loginLayout.removeLoading()
          @loginLayout.removeTags()

          @loginFormView = new App.LoginsApp.New.Form(model: new Backbone.Model({hosts:{}, services:{}}))

          # Create instance of access level view
          @access_level_view = App.request "creds:accessLevel:view", {model: new Backbone.Model({access_level:'Admin'}), save:false, showLabel:true}

          @listenTo @loginFormView, 'show' , () =>
            @updateServices()
            @loginFormView.hideHost()

            @show @access_level_view, region: @loginFormView.accessLevelRegion

          @show @loginFormView, region: @loginLayout.form

        @show @loginLayout, region: @_mainView.loginFormContainer

        # Show tagging and tabs component
        @show @tabController, region: @_mainView.formContainer


      # Update the service dropdown with services for the selected host
      # @param [Object] args options passed in by view trigger
      updateServices: () ->
        @host_id = HOST_ID

        @services = App.request "services:entities", {host_id: @host_id}
        @services.fetch(reset:true).then(@_updateServiceForm)

      # Helper method to update service dropdown
      _updateServiceForm: () =>
        @loginFormView.model.set('services',@services.toJSON())
        @loginFormView.render()
        @loginFormView.hideHost()
        # Create instance of access level view
        @access_level_view = App.request "creds:accessLevel:view", {model: new Backbone.Model({access_level:'Admin'}), save:false, showLabel:true}
        @show @access_level_view, region: @loginFormView.accessLevelRegion

      #Patch Cred to contain login data
      onFormSubmit: () ->
        $(':checked', @_mainView.ui.cred_type).val('login')
        data = Backbone.Syphon.serialize(@loginLayout)
        @model.set('login', data)
        super


    # Register an Application-wide handler for a cred controller
    #
    # @see {New.Controller#initialize} options
    App.reqres.setHandler 'creds:new', (opts = {})->
      if opts.login?
        new New.LoginController opts
      else
        new New.Controller opts
