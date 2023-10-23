define [
  'base_layout'
  'base_view'
  'base_itemview'
  'apps/brute_force_guess/index/templates/index_layout'
], () ->
  @Pro.module 'BruteForceGuessApp.Index', (Index, App, Backbone, Marionette, $, _) ->

    class Index.Layout extends App.Views.Layout
      template: @::templatePath 'brute_force_guess/index/index_layout'

      regions:
        contentRegion: '#content-region'
