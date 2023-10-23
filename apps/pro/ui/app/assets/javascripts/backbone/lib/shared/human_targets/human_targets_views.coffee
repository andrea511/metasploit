define [
  'base_layout'
  'base_view'
  'base_itemview'
  'lib/shared/human_targets/templates/layout'
], () ->
  @Pro.module 'Shared.HumanTargets', (HumanTargets, App, Backbone, Marionette, $, _) ->

    class HumanTargets.Layout extends App.Views.Layout
      template: @::templatePath 'human_targets/layout'

      regions:
        targetsRegion:  '#human-targets-region'


