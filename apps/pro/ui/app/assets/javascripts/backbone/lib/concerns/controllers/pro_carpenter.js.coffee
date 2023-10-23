define [
  'lib/components/table/table_view'
], ->
  @Pro.module "Concerns", (Concerns, App, Backbone, Marionette, $, _) ->
    #
    # Pro specific carpenter controller concern
    #
    Concerns.ProCarpenter =

      initialize: ->
        @initializeFilter() if @filterOpts

        # Tell the collection NOT to fetch if we are rendering static data
        @collection.bootstrap() if @static

        #B/C Carpenter clones the collection and makes a shallow copy :-(
        @collection.carpenterRadio = @carpenterRadio

        @carpenterRadio.off 'error:search'

        @carpenterRadio.on 'error:search', (message) =>
          @collection.reset()

          App.execute 'flash:display',
            title:   'Error in search'
            style:   'error'
            message: message || 'There is an error in your search terms.'

      #
      # Setup for filter component to work
      #
      initializeFilter: ->
        switch @filterOpts.searchType
          when 'pro' then @initializeProSearchFilter()
          else            @initializeVisualSearchFilter()

        @show @filter, region: if @filterOpts.filterRegion? then @filterOpts.filterRegion else @getMainView().filterRegion

      #
      # New VisualSearch filter component
      #
      initializeVisualSearchFilter: ->
        # This set's the filters searchBox text to the initial query (but doesn't execute query)
        # Note VisualSearch requires a space after the facet key to handle quoted values
        # Model::Search syntax, however, requires NO spaces
        # ex, "private.type: 'Metasploit::Credential::SSHKey'", the space allows proper tokenization
        if @search
          @fetch = false
          @filterOpts.query = @addWhiteSpaceToQuery(@search)

        @staticFacets = @filterOpts.staticFacets

        @filter = App.request 'filter:component', @

        # Apply intial filter query (must be done after filter:component requested)
        @applyCustomFilter(@search) if @search

        # Listen to the filter's query event
        @listenTo @filter, 'filter:query:new', (query) =>
          @toggleInteraction false
          @applyCustomFilter(query)

      #
      # Legacy pro_search filter
      #
      initializeProSearchFilter: ->
        @filter = App.request 'pro:search:filter:component', @

        @listenTo @filter, 'pro:search:filter:query:new', (query) =>
          @toggleInteraction false
          @applyProSearchFilter(query)

      #
      # For new VisualSearch filter component
      # applies a custom filter String (of the form "key1:val1 key2:val2") to the Collection
      # @param filter [String] the custom query string to parse and apply as a filter
      #
      applyCustomFilter: (query) ->
        @list.setSearch
          attributes:
            custom_query: query

      #
      # Legacy pro_search filter
      # query is a pure string with no fancy facet/key business
      #
      # @param filter [String] the custom query string to parse and apply as a filter
      #
      # @example applyProSearchFilter('doge')
      #
      applyProSearchFilter: (query) ->
        @list.setSearch
          attributes:
            pro_search_query: query

      #
      # Formats query string to be compatible with VisualSearch
      # (simply adds whitespace to a single ':' separator
      # @param query [String]
      # example: query = "private.type:'Metasploit::Credential::Password'"
      # example output:  "private.type: 'Metasploit::Credential::Password'"
      #                                ^ whitespace inserted
      #
      addWhiteSpaceToQuery: (query) ->
        query.replace(/([^:]):([^:\s])/g, "$1: $2")

      # TODO: Move this into carpenter repo.
      # Does an AJAX Post on the collection's URL, sending the table hash
      #  to tell the server to only return a success or failure.
      #
      # @param tableSelections [Object] data about the current state of the table's selections
      #
      # @return [Deferred] jquery deferred object
      postTableState: (opts) ->
        data =
          ui: true
          selections:
            select_all_state: ( @tableSelections.selectAllState || null )
            selected_ids:     Object.keys @tableSelections.selectedIDs
            deselected_ids:   Object.keys @tableSelections.deselectedIDs
          search: @collection.server_api.search
          ignore_pagination: true

        opts.data ||= {}

        _.extend(opts.data,data)

        defaultOpts =
          method: 'POST'
          url: _.result(@collection, 'url')
          dataType: 'json'

        _.defaults opts, defaultOpts

        $.ajax(opts)