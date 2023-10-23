define [
  'base_controller'
  'lib/components/content_container/content_container_views'
], ->
  @Pro.module "Components.ContentContainer", (ContentContainer, App, Backbone, Marionette, $, _) ->
    class ContentContainer.Controller extends App.Controllers.Application

      # Create new instance of the Content Container
      #
      initialize: (options) ->
        {@contentView, @headerView} = options

        @layout = new ContentContainer.Layout()
        @listenTo @layout, 'show', () ->
          if @contentView?
            @show @contentView, region: @layout.content
          if @headerView?
            @show @headerView, region: @layout.header


        @setMainView(@layout)

      showContentRegion: (contentView) ->
        @contentView = contentView
        @show @contentView, region: @layout.content

    # Register an Application-wide handler for a content container controller
    App.reqres.setHandler 'contentContainer:component', (options={})->
      new ContentContainer.Controller options