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
    class Entities.BruteForceReuseOptions extends App.Entities.Model

      defaults:
        service_seconds: 60*15
        overall_hours: 4
        overall_minutes: 0
        overall_seconds: 0
        limit: false
        run_type: 'reuse'

      mutators:
        overall_timeout: ->
          Math.floor(@get('overall_hours')) * 60*60 +
          Math.floor(@get('overall_minutes')) * 60 +
          Math.floor(@get('overall_seconds'))

        service_timeout: ->
          Math.floor(@get('service_seconds'))

        stop_on_success: ->
          !!@get('limit')

    #
    # API
    #

    API =
      newBruteForceReuseOptions: (attributes={}) ->
        new Entities.BruteForceReuseOptions(attributes)

    #
    # REQUEST HANDLERS
    #
    App.reqres.setHandler 'new:brute_force_reuse_options:entity', (attributes={}) ->
      API.newBruteForceReuseOptions attributes
