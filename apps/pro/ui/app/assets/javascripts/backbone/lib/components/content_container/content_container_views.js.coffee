define [
  'jquery'
  'base_layout'
  'lib/components/content_container/templates/layout'
], ($) ->
  @Pro.module "Components.ContentContainer", (ContentContainer, App) ->

    #
    # The content container layout
    #
    class ContentContainer.Layout extends App.Views.Layout
      template: @::templatePath "content_container/layout"

      regions:
        header:  '.header-region'
        content:    '.content-region'



