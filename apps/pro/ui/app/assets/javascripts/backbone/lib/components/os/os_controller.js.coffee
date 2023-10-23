define [
  'base_controller'
  'lib/components/os/os_views'
  'css!css/components/os'
], () ->
  @Pro.module "Components.Os", (Os, App) ->

    #
    # Contains the Pill
    #
    class Os.Controller extends App.Controllers.Application

      # Hash of default options for controller
      # @option opts color       [String] the color for the pill
      # @option opts content     [String] the content for the pill
      #
      defaults: ->
        content: 'Default Content'

      # Create a new instance of the Tooltip Controller and adds it to the
      # region passed in through the options hash
      #
      # @param [Object] options the option hash
      initialize: (options = {}) ->
        config = _.defaults options, @_getDefaults()
        model = new Backbone.Model(config)
        view = new Os.View()

        # Add Mutator to parse module icons
        _.extend(model.get('model'),{
          mutators:
            parsedIcons:
              get: ->
                JSON.parse(this.get('module_icons'))
        })

        view.model = model

        @setMainView(view)


    # Register an Application-wide handler for a tooltip controller
    App.reqres.setHandler 'os:component', (options={})->
      new Os.Controller options