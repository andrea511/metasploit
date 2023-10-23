define [
  'jquery'
  'base_itemview'
  'lib/components/os/templates/view'
], ($) ->
  @Pro.module "Components.Os", (Os, App, Backbone, Marionette, $, _) ->

    #
    # OS View
    #
    class Os.View extends App.Views.Layout
      template: @::templatePath "os/view"

      className: 'icon-logo'

