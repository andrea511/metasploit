define [
  'base_controller'
  'lib/shared/attempt_session/attempt_session_views'
  'lib/shared/payload_settings/payload_settings_controller'
  'entities/login'
], ->
  @Pro.module "Shared.AttemptSession" , (AttemptSession, App) ->

    #
    # Contains the Attempt Session button and polling logic
    #
    class AttemptSession.Controller extends App.Controllers.Application

      # Create a new instance of the AttemptSession Controller and adds it to the
      # region passed in through the options hash
      #
      # @param [Object] options the option hash
      initialize: (options = {}) ->
        model = App.request "new:login:entity", options.model.toJSON()
        @setMainView(new AttemptSession.ItemView(model: model))

        @listenTo @_mainView, 'btnClicked', () =>
          @payloadModel ?= App.request 'shared:payloadSettings:entities', {}

          App.execute 'showModal', new Pro.Shared.PayloadSettings.Controller(model:@payloadModel),
            modal:
              title: 'Payload Settings'
              description: ''
              width: 400
              height: 330
            buttons: [
              {name: 'Close', class: 'close'}
              {name: 'OK', class: 'btn primary'}
            ]
            loading: true
            doneCallback: () =>
              @_mainView.launchAttempt(@payloadModel)



    # Reqres Handler to create the AttemptSession Controller
    App.reqres.setHandler "attemptSession:shared", (options={}) ->
      new AttemptSession.Controller options
