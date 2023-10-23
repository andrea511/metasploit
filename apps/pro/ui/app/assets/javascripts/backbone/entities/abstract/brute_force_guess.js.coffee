define [
  'base_model'
  'base_collection'
  'lib/concerns/entities/input_generator'
], ->
  @Pro.module "Entities", (Entities, App, Backbone, Marionette, jQuery, _) ->

    class Entities.BruteForceGuessForm extends Entities.Model
      @include "InputGenerator"

      url: () ->
        Routes.workspace_brute_force_guess_runs_path(WORKSPACE_ID)

      mutators:
        overall_timeout: ->
          hash = @get('quick_bruteforce')?.options || @get('bruteforce')?.quick_bruteforce.options
          hour = Math.floor(hash.overall_timeout.hour)
          minutes = Math.floor(hash.overall_timeout.minutes)
          seconds = Math.floor(hash.overall_timeout.seconds)

          hour * 60*60 +
            minutes * 60 +
          seconds


    API =
      newBruteForceGuessForm: (attributes={}) ->
        new Entities.BruteForceGuessForm(attributes)


    App.reqres.setHandler "new:brute_force_guess_form:entity", (attributes = {}) ->
      API.newBruteForceGuessForm attributes
