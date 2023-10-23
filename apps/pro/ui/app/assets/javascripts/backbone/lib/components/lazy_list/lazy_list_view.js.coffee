define [
  'jquery'
  'base_compositeview'
  'base_itemview'
  'base_layout'
  'lib/components/lazy_list/lazy_list_collection'
  'lib/components/lazy_list/templates/list'
  'lib/components/lazy_list/templates/load_more'
  'lib/components/lazy_list/templates/layout'
], ($) ->

  @Pro.module "Components.LazyList", (LazyList, App) ->

    #
    # The Layout is a container that houses List and LoadMore subviews. The
    # Controller is in charge of creating and managing these subviews.
    #
    class LazyList.Layout extends App.Views.Layout

      template: @::templatePath('lazy_list/layout')

      attributes:
        class: 'lazy-list-component nano'

      regions:
        list: '.list'
        loadMore: '.load-more'

      onShow: ->
        @$el.css('height', @$el.height())
        @$el.nanoScroller()

      resetScroller: =>
        @$el.nanoScroller()

      onDestroy: ->
        @$el.nanoScroller(destroy: true)

    #
    # The LoadMoreView contains the (possibly hidden) button that, when clicked,
    #  loads the next page of results.
    #
    class LazyList.LoadMore extends App.Views.ItemView

      template: @::templatePath('lazy_list/load_more')

      triggers:
        click: 'loadMoreClicked'

      attributes:
        class: 'load-more'

      # @property [String] the text displayed in the Load More button
      loadMoreLabel: "Load More"

      initialize: ({@collection, loadMoreLabel, modelsLoaded}) =>
        @collection.modelsLoaded = modelsLoaded || @collection.modelsLoaded
        @loadMoreLabel = loadMoreLabel || @loadMoreLabel
        @listenTo @collection, 'fetched', => _.defer(@render)
        @listenTo @collection, 'reset', => _.defer(@render)

      serializeData: -> @

    class LazyList.EmptyView extends App.Views.ItemView
      attributes:
        class: 'empty-view'
      template: -> 'Nothing is selected.'

    #
    # The List view renders the fetched pages of the collection.
    #
    class LazyList.List extends App.Views.CompositeView

      template: @::templatePath('lazy_list/list')

      childView: App.Views.ItemView

      emptyView: LazyList.EmptyView

      childViewContainer: '.stuff'

      attributes:
        class: 'lazy-list collection-loading'

      collectionEvents:
        fetched: 'fetched'
        loadingMore: 'loadingMore'

      # @property [Boolean] the view is loading
      loading: true


      buildChildView: (item, ItemViewType, itemViewOptions) =>
        opts = _.extend({ model: item, collection: @collection }, itemViewOptions)
        new ItemViewType(opts)

      # @param opts [Object] the options hash
      # @option opts collection [Backbone.Collection] the collection to render
      # @option opts childView [Backbone.View] the Item View that is rendered per result
      # @option opts loadMoreLabel [String] the text displayed in the Load More button
      # @option opts ids [Array<Number>] all the selected IDs
      # @option opts perPage [Number] number of items per page
      initialize: (opts={}) ->
        # set some ivars from the opts hash
        _.extend @, _.pick(opts, 'childView', 'loadMoreLabel', 'collection')

        # Mix the LazyList behavior into the Collection
        Cocktail.mixin(@collection, App.Concerns.LazyListCollection)
        @collection.initializeLaziness(opts)

        # Set some properties on the collection based on +opts+
        #_.extend @collection, _.pick(opts, 'perPage', 'currPage', 'ids')


      showEmptyView: () ->
        #$(@el).nanoScroller({destroy:true})
        super

      # Called when the "fetched" collection event occurs
      fetched: =>
        @setLoading(false)
        #$(@el).nanoScroller();


      # Called when the "loadingMore" collection event occurs
      loadingMore: =>
        @setLoading(true)

      # @param loading [Boolean] show the "loading" style, which prevents interaction
      # @return [Boolean] loading state
      setLoading: (loading) =>
        @loading = loading
        @$el.toggleClass('collection-loading', loading)
        @loading

      serializeData: -> @
