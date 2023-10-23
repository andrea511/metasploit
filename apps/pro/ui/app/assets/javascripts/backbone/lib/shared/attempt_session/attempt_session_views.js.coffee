define [
  'jquery'
  'base_layout'
  'base_compositeview'
  'base_itemview'
  'lib/shared/attempt_session/templates/attempt_session'
  'entities/shared/payload_settings'
  'lib/concerns/pollable'
], ($) ->
  @Pro.module "Shared.AttemptSession", (AttemptSession, App) ->

    #
    # Targets Layout
    #
    class AttemptSession.ItemView extends App.Views.ItemView

      @include 'Pollable'

      template: @::templatePath "attempt_session/attempt_session"

      className: 'attempt-session-container'

      ui:
        attemptBtn: '.btn.primary.narrow'
        reloadBtn:'.btn.primary.reload'

      triggers:
        'click @ui.attemptBtn' : 'btnClicked'
        'click @ui.reloadBtn' : 'btnClicked'

      modelEvents:
        'change:attempting_session' : '_attemptingSessionChanged'

      # @property [Number] the rate (in ms) to poll for task status
      pollInterval: 3000

      # @property [Pro.Entities.Task] the task that is being polled to check validation status
      task: null


      launchAttempt: (@payloadModel) =>
        @model.set(attempting_session: true)
        @model.set(completed: false)

      _attemptingSessionChanged: =>
        @render() # show spinner
        if @model.get('attempting_session')
          @model.attemptSession(@payloadModel).done (task) =>
            @setTask(task)
            @startPolling()

      poll: ->
        if @task.isCompleted()
          @stopPolling()
          @model.sessions().done (session) =>
            @model.set(session: session)
            @model.set(completed: true)
            @model.set(attempting_session: false)
        else
          @task.fetch()

      setTask: (@task) =>

      serializeData: => @
