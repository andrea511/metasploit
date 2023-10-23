define [
  'base_controller'
  'apps/brute_force_guess/index/index_views'
  'apps/brute_force_guess/quick/quick_controller'
], ->
  @Pro.module "BruteForceGuessApp.Index", (Index, App) ->
    class Index.Controller extends App.Controllers.Application

      initialize: (options)->

        _.defaults options,
          show: true
          taskChain:false

        {show,taskChain, payloadModel, mutationModel} = options


        @layout = new Index.Layout()
        @setMainView(@layout)

        @listenTo @_mainView, 'show', =>
          @quickBruteforce = new Pro.BruteForceGuessApp.Quick.Controller(
            taskChain:taskChain
            payloadModel: payloadModel
            mutationModel: mutationModel
          )
          @show @quickBruteforce, region: @_mainView.contentRegion

        @show @_mainView if show

      getPayloadSettings: ->
        @quickBruteforce.payloadModel