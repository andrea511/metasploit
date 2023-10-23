define [
  'base_controller'
  'apps/brute_force_reuse/review/review_views'
  'lib/shared/targets/targets_views'
], () ->
  @Pro.module "BruteForceReuseApp.Review" , (Review, App) ->

    #
    # Contains the Targets
    #
    class Review.Controller extends App.Controllers.Application

      # Hash of default options for controller
      # @option opts buttons      [Object] the default button set
      #
      defaults: ->


        # Create a new instance of the Target Controller and adds it to the
        # region passed in through the options hash
        #
        # @param [Object] options the option hash
      initialize: (options = {}) ->
        @workspace_id = options.workspace_id || WORKSPACE_ID
        #Set default key/values if key not defined in options hash
        config = _.defaults options, @_getDefaults()

        {@targetListCollection, @workingGroup, @reuseOptions} = options

        @setMainView(new Review.Layout(model: @reuseOptions))

        @listenTo @_mainView, 'form:changed', ->
          data = Backbone.Syphon.serialize @_mainView

          changed = false
          _.each ['service_seconds', 'overall_hours', 'overall_seconds', 'overall_minutes'], (o) ->
            newData = (data[o]+'').replace(/[^0-9]/g, '')
            if newData isnt data[o]
              changed = true
              data[o] = newData

          @reuseOptions.set(data)
          if changed
            Backbone.Syphon.deserialize(@_mainView, data)

        @listenTo @_mainView, 'show', ->
          Backbone.Syphon.deserialize @_mainView, @reuseOptions.toJSON()

          @targetList = new App.Shared.TargetList.Controller(targetListCollection: @targetListCollection )

          @groups = new App.BruteForceReuseApp.CredSelection.GroupsContainer(_.pick(options,'workingGroup'))

          @listenTo @groups, 'show', ->
            @groups.selectionUpdated()

          @show @targetList, region: @_mainView.targetRegion
          @show @groups, region: @_mainView.credRegion

        @listenTo @targetListCollection, 'remove', ->
          if @targetListCollection.length == 0
            @_mainView.disableLaunch()

        @listenTo @workingGroup.get('creds'), 'remove', ->
          if @workingGroup.get('creds').length == 0
            @_mainView.disableLaunch()

        @listenTo @getMainView(), 'targets:back' , ->
          App.vent.trigger ('crumb:targets')

        @listenTo @getMainView(), 'credentials:back', ->
          App.vent.trigger('crumb:credentials')
