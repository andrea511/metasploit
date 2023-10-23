define [
  'base_controller'
  'lib/components/lazy_list/lazy_list_view'
], ->

  @Pro.module 'Components.LazyList', (LazyList, App) ->

    #
    # The LazyList component, when given a collection, will load
    # only @perPage entries into the rendered collection view.
    #
    # The user can specify the ItemView for rendering each element in
    # the collection.
    #
    class LazyList.Controller extends App.Controllers.Application

      # @property [Backbone.Collection] the collection to render
      collection: null

      # @property [LazyList.LoadMore] the View instance containing the Load More button
      loadMoreView: null

      # @property [LazyList.List] the CollectionView instance
      listView: null

      # Create a new instance of TableController and adds it to
      # the main region of the local Application.
      #
      # @param [Object] opts the options hash
      # @option opts collection [Backbone.Collection] a collection to render
      # @option opts itemView [Backbone.View] the Item View that is rendered per result
      # @option opts loadMoreLabel [String] the text displayed in the Load More button
      # @option opts ids [Array<Number>] all the selected IDs
      # @option opts perPage [Number] number of items per page
      initialize: (opts={}) ->
        # Set a few ivars on ourself
        _.extend @, _.pick(opts, 'collection')
        _.defaults(opts, show: true)

        # Create the LazyList Layout
        @layout = new LazyList.Layout
        @setMainView(@layout)


        # Create the LazyList subviews
        @listView = new LazyList.List(opts)
        @loadMoreView = new LazyList.LoadMore(opts)

        # Load the items from the collection and render subviews on show
        @listenTo @layout, 'show', =>
          @show @listView, region: @layout.list, preventDestroy:true
          @show @loadMoreView, region: @layout.loadMore, preventDestroy:true

          unless @collection.currPage > 0 or not opts.ids? || opts.ids.length < 1
            @collection.loadMore()
          else
            @collection.trigger('fetched')

        @listenTo @loadMoreView, 'loadMoreClicked', =>
          @collection.loadMore()
          @listView.setLoading(true)

        @listenTo @collection, 'fetched reset', =>
          _.defer @layout.resetScroller

        # Showtime
        @show @layout, region: opts.region if opts.show

      resize: =>
        @layout.resetScroller()

      addIDs: (ids) =>
        if ids?.length > 0
          @collection.addIDs(ids)
          @collection.loadMore()

    # Register an Application-wide handler for rendering a table component
    App.reqres.setHandler 'lazy_list:component', (options={}) ->
      new LazyList.Controller(options)
