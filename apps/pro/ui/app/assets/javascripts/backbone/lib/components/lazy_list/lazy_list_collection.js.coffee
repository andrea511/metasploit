define [
  'jquery'
], ($) ->

  @Pro.module "Concerns", (Concerns, App) ->

    #
    # The Pro.Concerns.LazyListCollection mixin adds behavior to
    # a standard Marionette Collection for loading "pages" of results,
    # with a Load More entry at the bottom of the set.
    #
    Concerns.LazyListCollection =

      # @property [Array<Number>] the id of every model in this collection.
      #   The collection will refer to this when loading the next page.
      ids: null

      # @property [Number] number of items per page
      perPage: 20

      # @property [Number] zero-based offset of the last loaded page
      currPage: 0

      # @property [Number] total number of individual models (rows) loaded
      modelsLoaded: 0

      # @property [Object] a hash of IDs for quickly validating uniqueness
      _idsHash: null

      #
      # The loadMore method is mixed into a normal Backbone.Collection at
      # runtime. It enables an arbitrary collection to be loaded in "chunks",
      # where the individual model IDs in the chunks are known by the client
      # ahead of time.
      #
      # @param opts [Object] the options hash
      # @option opts attemptsLeft [Number] on error, number of times to try again (5).
      #
      loadMore: (opts={}) ->
        return if @modelsLoaded >= @ids.length

        _.defaults(opts, attemptsLeft: 5)

        data =
          with_ids: @ids[@itemOffset()...(@itemOffset()+@perPage)].join(',')

        @trigger('loadingMore')

        $.getJSON(_.result(@, 'url'), data)
          .done (results) =>
            @currPage++
            @modelsLoaded += @perPage
            @_updateModelsLoaded()
            _.each results, (hash) => @add(new @model(hash))
            @trigger('fetched')

          .error =>
            # Oops. Something went wrong. Let's try this again in 3s.
            unless opts.attemptsLeft < 1
              _.delay((=> @loadMore(attemptsLeft: opts.attemptsLeft-1)), 3000)

      # This function needs to be called after the mixin is performed
      initializeLaziness: (opts) ->
        @perPage = opts.perPage || @perPage
        @currPage = opts.currPage || @currPage
        @ids = opts.ids || @ids

        unless @laziness
          @ids ||= []
          @_idsHash = {}
          @modelsLoaded = 0
          @laziness=true

      # Add some IDs to the global list of IDs in this collection. Some of these
      # IDs might have already been added, so we ensure uniqueness.
      addIDs: (ids) ->
        _.each ids, (id) =>
          id = Math.floor(id)
          unless @_idsHash[id]?
            @ids.push(id)
            @_idsHash[id] = true

      # @return [Number] the number of models that we have currently loaded
      itemOffset: -> @models.length

      # Hook the Collection.prototype.remove function to yank our model out of ids arrays
      remove: (model) ->
        id = Math.floor(model.id)
        # remove the id from our lookup hash
        delete @_idsHash[id]
        # remove the id from the ids array without copying
        idIdx = _.indexOf @ids, id
        @ids.splice(idIdx, 1) if idIdx > -1
        @_updateModelsLoaded()

      reset: ->
        @ids = []
        @_idsHash = {}
        @_updateModelsLoaded()

      # Resets the @modelsLoaded property to ensure correctness
      _updateModelsLoaded: ->
        @modelsLoaded = _.min([@modelsLoaded, @ids.length])
