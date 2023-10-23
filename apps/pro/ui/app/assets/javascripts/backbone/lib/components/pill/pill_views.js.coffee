define [
  'jquery'
  'base_itemview'
  'lib/components/pill/templates/view'
], ($) ->
  @Pro.module "Components.Pill", (Pill, App, Backbone, Marionette, $, _) ->

    #
    # Pill View
    #
    class Pill.View extends App.Views.Layout
      template: @::templatePath "pill/view"

