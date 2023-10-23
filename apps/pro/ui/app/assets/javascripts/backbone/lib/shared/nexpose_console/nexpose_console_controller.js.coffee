define [
  'base_controller'
  'lib/shared/nexpose_console/nexpose_console_views'
  'entities/nexpose/console'
  'css!css/shared/nexpose_console'
], ->
  @Pro.module "Shared.NexposeConsole" , (NexposeConsole, App, Backbone, Marionette, $, _ ) ->
    CONNECTION_CONFIRM_MSG = 'Unable to connect to the Nexpose instance. '+
        'Would you like to save the Nexpose Console anyways?'

    #
    # Contains the Nexpose Console Form
    #
    class NexposeConsole.Controller extends App.Controllers.Application

      # Create a new instance of the Nexponse Console Controller and adds it to the
      # region passed in through the options hash
      #
      # @param [Object] options the option hash
      initialize: (options = {}) ->
        @model = App.request 'new:nexpose:console:entity'

        @setMainView(new NexposeConsole.Form())


      # "Interface" Method required by Modal Component
      onFormSubmit: () ->
        # jQuery Deferred Object that closes modal when resolved.
        defer = $.Deferred()
        defer.promise()

        callbacks = {
          success: (model, response, options) =>
            json = response
            # If connection made but password is wrong
            if !json.connection_success and json.message.match(/API error/)
              @trigger("btn:enable:modal", "Connect To Nexpose")
              @_mainView.setLoading(false)
              @_mainView.showErrors({ 'password': [ 'is incorrect' ] })
              new @model.constructor(id: json.id).destroy()
            else
              @_mainView.setLoading(false)
              @_mainView.toggleConnectionStatus(json.connection_success)
              #If console valid
              if json.connection_success
                @_mainView.clearErrors()
                @trigger('consoleAdded:nexposeConsole', json)
                setTimeout((=>
                  defer.resolve()
                ), 800)
              else
                if confirm(CONNECTION_CONFIRM_MSG)
                  defer.resolve()
                else
                  @trigger("btn:enable:modal", "Connect To Nexpose")
                  # oops. let's kill that NexposeConsole actually.
                  new @model.constructor(id: json.id).destroy()

          error: (model, response, options) =>
            @trigger("btn:enable:modal", "Connect To Nexpose")
            @_mainView.setLoading(false)
            @_mainView.showErrors(response.responseJSON.errors)
        }

        @model.clear()
        formData = Backbone.Syphon.serialize(@_mainView)
        @model.set(formData.nexpose_console)
        @_mainView.setLoading(true)
        @trigger("btn:disable:modal", "Connect To Nexpose")
        @model.save({}, callbacks)

        defer

    # Reqres Handler to create the Nexpose Console Controller
    App.reqres.setHandler "nexposeConsole:shared", (options={}) ->
      new NexposeConsole.Controller options

    # App exec handler for showing nexpose console modal
    App.commands.setHandler 'show:nexposeConsole', (consoleController) ->
      App.execute 'showModal', consoleController,
        modal:
          title: 'Configure Nexpose Console'
          description: ''
          width: 600
          class: 'no-border'
        buttons: [
          {name: 'Cancel', class: 'close'}
          {name: 'Connect To Nexpose', class: 'btn primary'}
        ]
