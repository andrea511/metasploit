define [
  'base_controller'
  'lib/components/stars/stars_views'
  'css!css/components/stars'
], () ->
  @Pro.module "Components.Stars", (Stars, App) ->
    #
    # Contains the row of stars
    #
    class Stars.Controller extends App.Controllers.Application

      # Default rating
      RATING: 5

      # Hash of default options for controller
      # @option opts rating       [Integer] the default number of stars shown
      #
      defaults: ->
        rating: @RATING

      # Create a new instance of the Stars Controller and adds it to the
      # region passed in through the options hash
      #
      # @param [Object] options the option hash
      initialize: (options = {}) ->
        config = _.defaults options, @_getDefaults()
        model = new Backbone.Model(config)
        view = new Stars.View()
        view.model = model

        @setMainView(view)


    # Register an Application-wide handler for a stars controller
    App.reqres.setHandler 'stars:component', (options={})->
      new Stars.Controller options