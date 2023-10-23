define [
  'base_model'
  'base_collection'
], ->
  @Pro.module "Entities", (Entities, App) ->

    #
    # ENTITY CLASSES
    #

    #
    # A single brute force guess.
    #
    class Entities.BruteForceRun extends App.Entities.Model

      defaults:
        workspace_id: null
        host_ids: []
        credential_ids: []
        config: {}

      url: ->
        "/workspaces/#{@get('workspace_id')}/brute_force/runs.json"

    #
    # API
    #

    API =
      newBruteForceRun: (attributes={}) ->
        new Entities.BruteForceRun(attributes)

    #
    # REQUEST HANDLERS
    #

    App.reqres.setHandler "new:brute_force_run:entity", (attributes={}) ->
      API.newBruteForceRun attributes
