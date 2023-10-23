define [
  'base_layout'
  'apps/imports/sonar/templates/sonar_layout'
  'apps/imports/sonar/sonar_domain_input_view'
  'apps/imports/sonar/sonar_result_view'
], () ->
  @Pro.module 'ImportsApp.Sonar', (Sonar, App, Backbone, Marionette, $, _) ->

    class Sonar.Layout extends App.Views.Layout
      template: @::templatePath 'imports/sonar/sonar_layout'

      regions:
        domainInputRegion: "#sonar-domain-input-region"
        resultsRegion:     "#sonar-results-region"

      initialize: (opts={}) ->
        { @importsIndexChannel } = opts


    #
    # Display error message
    #
    # @see {Flash.FlashController}
    #
    App.commands.setHandler "sonar:imports:display:error", (opts) ->
      opts = _.defaults opts,
        title:   'An error occurred'
        style:   'error'
        message: "There was a problem pushing the results to Nexpose."
      App.execute 'flash:display', opts