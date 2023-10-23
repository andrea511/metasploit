define [
  'jquery'
  'base_itemview'
  'lib/components/stars/templates/view'
], ($) ->
  @Pro.module "Components.Stars", (Stars, App, Backbone, Marionette, $, _) ->

    #
    # Stars View
    #
    class Stars.View extends App.Views.ItemView
      template: @::templatePath "stars/view"

