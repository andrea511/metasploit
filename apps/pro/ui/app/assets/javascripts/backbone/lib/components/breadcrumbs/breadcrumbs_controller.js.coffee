define [
  'base_controller'
  'lib/components/breadcrumbs/breadcrumbs_views'
  'lib/entities/abstract/crumbs'
], () ->
  @Pro.module "Components.Breadcrumbs" , (Breadcrumbs, App) ->

    #
    # Contains the breadcrumbs
    #
    class Breadcrumbs.BreadcrumbsController extends App.Controllers.Application

      # Hash of default options for controller
      # @option opts crumbs      [Object] the default crumb set
      #
      defaults: ->
        crumbs: [
          {title: 'Crumb 1'}
          {title: 'Crumb 2'}
          {title: 'Crumb 3'}
          {title: 'Crumb 4'}
        ]

      # Create a new instance of the Crumb Controller and adds it to the
      # region passed in through the options hash
      #
      # @param [Object] options the option hash
      # @option opts buttons   [Object] the config options to create the Bread Crumbs Model
      initialize: (options = {}) ->
        #Set default key/values if key not defined in options hash
        config = _.defaults options, @_getDefaults()

        # Get Crumbs Model and View and set as controller's view
        @crumbsCollection = @getCrumbs(config.crumbs)
        @collectionView = @getCollectionView(@crumbsCollection)
        @setMainView(@collectionView)

      # Create collection view of crumbs
      #
      # @param [Backbone.Collection] crumbs a collection of Crumbs Models
      # @return [Views.CollectionView] a collection view of crumbs
      getCollectionView: (crumbs) ->
        new Breadcrumbs.CrumbCollection
          collection: crumbs


      # Request to create a collection of Crumbs
      #
      # @param [Array<Object>] buttons an array of crumb config hashes
      # @return [Backbone.Collection] a collection of Crumb Models
      getCrumbs: (crumbs) ->
        App.request "crumbs:entities", crumbs

    # Reqres Handler to create the Crumbs Component Controller
    App.reqres.setHandler "crumbs:component", (options={})->
      new Breadcrumbs.BreadcrumbsController options