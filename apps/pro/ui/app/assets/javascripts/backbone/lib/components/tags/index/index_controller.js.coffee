define [
  'jquery'
  'base_controller'
  'lib/components/tags/index/index_view'
], ($) ->
  @Pro.module "Components.Tags.Index", (Index, App, Backbone, Marionette, $, _) ->
    class Index.Controller extends App.Controllers.Application

      #
      # Create a new instance of IndexController
      #
      # @option opts model    [Entity.Model] model containing tags
      #
      initialize: (options) ->
        {@model, @serverAPI} = options

        @setMainView(new Index.Layout { @model })

        # After Layout is shown, show tag count and render tag hover markup (hidden)
        @listenTo @_mainView, 'show', =>
          @tagCompositeView = new Index.TagCompositeView { @model, @serverAPI }

          @listenTo @tagCompositeView, 'tag:increment',(count)->
            @_mainView.increment(count)

          @listenTo @tagCompositeView, 'tag:decrement' , ->
            @_mainView.decrement()

          @show @tagCompositeView, region: @_mainView.tagHover

        # Listen to view event to show tags hover
        @listenTo @_mainView, 'show:tag:hover', ->
          @tagCompositeView.clearTagHovers()
          @tagCompositeView.showTags()

        # Listen to view event to hide hover
        @listenTo @_mainView, 'hide:tag:hover', ->
          @tagCompositeView.hideTags()


    # Reqres Handler to create the Tag Component Controller
    App.reqres.setHandler 'tags:index:component', (options={})->
      if options.instantiate?
        new Index.Controller(options)
      else
        Index.Controller
