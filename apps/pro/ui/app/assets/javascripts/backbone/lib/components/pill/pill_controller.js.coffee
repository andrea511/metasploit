define [
  'base_controller'
  'lib/components/pill/pill_views'
  'css!css/components/pill'
], () ->
  @Pro.module "Components.Pill", (Pill, App) ->

    #
    # Contains the Pill
    #
    class Pill.Controller extends App.Controllers.Application

      COLORS:
        RED: 'red'
        GREEN: 'green'
        BLACK: 'black'
        BLUE: 'blue'

      # Hash of default options for controller
      # @option opts color       [String] the color for the pill
      # @option opts content     [String] the content for the pill
      #
      defaults: ->
        color: @COLORS.RED
        content: 'Default Content'

      # Create a new instance of the pill controller and adds it to the
      # region passed in through the options hash
      #
      # @param [Object] options the option hash
      initialize: (options = {}) ->
        config = _.defaults options, @_getDefaults()
        model = new Backbone.Model(config)
        view = new Pill.View()
        view.model = model

        @setMainView(view)


    # Register an Application-wide handler for a pill component
    App.reqres.setHandler 'pill:component', (options={})->
      new Pill.Controller options