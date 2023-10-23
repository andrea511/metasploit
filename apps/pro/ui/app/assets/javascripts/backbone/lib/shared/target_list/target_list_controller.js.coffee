define [
  'base_controller'
  'lib/shared/target_list/target_list_views',
  'entities/target'
], () ->
  @Pro.module "Shared.TargetList" , (TargetList, App) ->

    #
    # Contains the Targets
    #
    class TargetList.Controller extends App.Controllers.Application

      # Hash of default options for controller
      # @option opts buttons      [Object] the default button set
      #
      defaults: ->

      # Create a new instance of the Target Controller and adds it to the
      # region passed in through the options hash
      #
      # @param [Object] options the option hash
      initialize: (options = {}) ->

        {@targetListCollection} = options

        layout = new TargetList.Layout()
        @setMainView(layout)

        @listenTo @_mainView, 'show', ->
          @lazyList = new App.Components.LazyList.Controller
            collection: @targetListCollection
            region: @_mainView.targetListRegion
            childView: App.Shared.Targets.Target
            ids: @targetListCollection.ids || []
            modelsLoaded: @targetListCollection?.modelsLoaded?.length || 0

          @listenTo @targetListCollection, 'add', @selectionUpdated
          @listenTo @targetListCollection, 'remove', @selectionUpdated
          @listenTo @targetListCollection, 'reset', @selectionUpdated

          _.defer =>
            @selectionUpdated()

        @listenTo @_mainView, 'removeTargets', () ->
          result= confirm("Are you sure you want to remove all targets?")
          if result then @targetListCollection.reset()

      selectionUpdated: =>
        @_mainView.updateClearState(@targetListCollection)
        @_mainView.updateSelectionCount(@targetListCollection)

