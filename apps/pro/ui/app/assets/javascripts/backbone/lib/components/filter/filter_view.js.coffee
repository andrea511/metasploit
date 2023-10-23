define [
  'jquery'
  'base_itemview'
  'visualsearch'
  'css!visualsearch-datauri'
  'lib/components/filter/templates/filter'
  'lib/components/filter/help_view'
  'lib/components/modal/modal_controller'
], ($) ->
  @Pro.module "Components.Filter", (Filter, App) ->

    #
    # A faceted filter search box
    #
    class Filter.FilterView extends App.Views.ItemView

      template: @::templatePath "filter/filter"

      ui:
        container: '.filter-component'
        helpLink: '.help-icon'

      events:
        'click @ui.helpLink': 'displayHelpModal'
        'focusin .VS-search-inner' : 'expandField'
        'focusout .VS-search-inner' : 'contractField'

      SORT_BY:
        asc: 'asc'
        desc: 'desc'

      defaults: ->
        container: @ui.container
        query: ''
        sortBy: @SORT_BY.asc
        autoFocusFacet: true
        autoFocusValue: false
        matchStartOfFacet: false
        matchStartOfValue: false
        enableFreeText: false
        supportDotInFacet: true,
        filterValuesEndpoint: ''
        callbacks:
          search: (query, searchCollection) =>
            @triggerQuery(@_rewriteQuery(query))
            @$VSsearch.removeClass 'animating'
          facetMatches: (callback) =>
            # If the field is currently animating its expansion, don't yet render
            # the facets dropdown.
            if @$VSsearch.hasClass 'animating'
              @$VSsearch.one "webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend", =>
                @$VSsearch.removeClass 'animating'
                callback @options.keys
            else
              callback @options.keys
          valueMatches: (facet, searchTerm, callback) =>
            searchTerm = @parseAddress(searchTerm) if facet == 'address'

            statics = if @staticFacets then Object.keys(@staticFacets) else []
            if facet in statics
              callback @staticFacets[facet]
            else
              @_fetchValues(facet, searchTerm, callback)

      initialize: (options) ->
        @staticFacets = @options.staticFacets
        @collection = @options.collection

      parseAddress: (searchTerm) ->
        addrFragments = _.without(searchTerm.split('.'), "")

        switch(addrFragments.length)
          when 1
            searchTerm = "#{addrFragments[0]}.0.0.0/8"
          when 2
            searchTerm = "#{addrFragments[0]}.#{addrFragments[1]}.0.0/16"
          when 3
            searchTerm = "#{addrFragments[0]}.#{addrFragments[1]}.#{addrFragments[2]}.0/24"

        searchTerm

      #
      # Expand the search field on focus.
      expandField: () ->
        @$VSsearch.addClass 'expanded animating' unless @$VSsearch.hasClass 'expanded'

      #
      # Contract the search field on blur, unless it's non-empty.
      contractField: ->
        if @currentQuery() == ""
          @ui.container.find('.VS-search').removeClass 'expanded'

      #
      # Set @options to options.filterOpts, if passed, or just to the options object
      setOptions: (options) ->
        # TODO: test this behavior
        opts = @options.filterOpts || @options
        _.defaults(opts, @defaults())
        @options = opts
        @filterValuesEndpoint = @options.filterValuesEndpoint
        @helpEndpoint = @options.helpEndpoint

      #
      # Calculate the URL for the API endpoint that returns the text for the
      # help modal.
      #
      # @return [String] the search operator info endpoint URL
      helpUrl: ->
        throw "helpEndpoint or collection must be provided in options" unless @helpEndpoint || @collection
        @helpEndpoint || @collection.url.replace(/(\.json)|(\/)$/, '') + '/search_operators.json'

      #
      # Display the help text for the search operators in a modal.
      #
      # TODO: Cache the response so that we aren't re-fetching on each request.
      displayHelpModal: ->
        HelpModel  = Backbone.Model.extend url: => @helpUrl()
        help = new HelpModel()
        keys = @_keysToString(@options.keys)
        App.execute 'showModal', new App.Filters.HelpView(model: help, whitelist: keys),
          modal:
            title: 'Search Filters'
            description: ''
            width: 600
            height: 600
          buttons: [
            { name: 'Close', class: 'close primary btn'}
          ]

      #
      # Map keys to be compatible with help search_operators.json
      # VS keys could be pure string or object, ex. {label: 'service.name', value: 'name'}
      #
      # @param [Array] keys
      #
      # @return [Array] keys coreced to proper string
      #
      # @example
      #   keys = ['host.address', {label: 'service.name', value: 'name'}
      #   _keysToString(keys)
      #   #=> ['host.address', 'name']
      #
      _keysToString: (keys) ->
        _.map(keys, (key)-> key.value || key )

      #
      # @lastKey optional, clears out the last key/value in query since VS doesn't do that by default
      #
      currentQuery: (lastKey)->
        query = if lastKey then @_clearLastQuery(lastKey) else @searchBox.currentQuery
        @_rewriteQuery(query)

      #
      # Clears the previous query string of any instance of provided @lastKey
      # ex. if the searchbox query was 'realm.key:"PostgreSQL Database" public.username:"abbey"'
      #     and you start typing a second public.username, it will clear out the last public.username facet
      #     so that the autocomplete dropdown is scoped to just realm.key:"PostgreSQL Database".
      #     The benefit of this is so the dropdown's list has more options than just listing the same
      #     public.username's in the first facet.
      #     Note that this only affects the automplete dropdown and not the triggered search query
      #     on the table. i.e. the triggered query can still takes in multiple public.username's
      #
      # @lastKey string, the value of facet key, ex 'public.username'
      #
      _clearLastQuery: (lastKey)->
        re = "\\s" + lastKey + ".*$"
        matcher = new RegExp(re, 'i');
        @searchBox.currentQuery.replace(matcher, '')

      _fetchValues: (key, searchTerm, callback) ->
        return if _.isBlank(searchTerm)
        searchTerm = '\"'+searchTerm+'\"'
        nextQuery    = if searchTerm == "" then "" else " #{key}:#{searchTerm}"
        enteredQuery = @currentQuery(key) + nextQuery
        data = { search: { custom_query: enteredQuery }}

        parts = key.split('.')
        data.ignore_pagination = true
        data.column = parts.pop()
        data.prefix = parts.pop()
        data.sort_by = "#{key} #{@options.sortBy}"
        $.getJSON @filterValuesEndpoint, data,
          (data, status) ->
            # TODO: error handle
            callback(data)


      _rewriteQuery: (query) ->
        parsedQuery = @_rewriteAddrQuery(query)
        parsedQuery.replace /\:\s/g, ':'

      _rewriteAddrQuery: (query) ->
        @visualSearch.searchQuery.each((model)=>
          model.set('value', @parseAddress(model.get('value'))) if model.get('category') == 'address'
        )

        @visualSearch.searchBox.serialize()


      onRender: ->
        # Setting this here, rather than in initialize, since we need access to
        # @ui.container in defaults.
        @setOptions()
        @resetVisualSearchTemplates()

        @visualSearch = VS.init @options
        @searchBox = @visualSearch.searchBox
        @$VSsearch = @searchBox.$el.find('.VS-search')

      #
      # Trigger a search query that ProCarpenter will pick up
      #
      # @return [void]
      #
      triggerQuery: (query)->
        @trigger 'filter:query:new', query

      #
      # Due to our resetting of _.templateSettings to use handlebar-style operators,
      # we must recompile the VisualSearch templates with ERB-style operators.
      resetVisualSearchTemplates: ->
        originalTemplateSettings = _.templateSettings

        _.templateSettings = {
          evaluate    : /<%([\s\S]+?)%>/g,
          interpolate : /<%=([\s\S]+?)%>/g,
          escape      : /<%-([\s\S]+?)%>/g
        }

        window.JST['search_box'] = @searchBoxTemplate()
        window.JST['search_facet'] = @searchFacetTemplate()
        window.JST['search_input'] = @searchInputTemplate()

        _.templateSettings = originalTemplateSettings


      #
      # TEMPLATES
      #

      # We can overwrite VisualSearch's default templates here.

      searchBoxTemplate: ->
        _.template(
          """
          <div class="VS-search <% if (readOnly) { %>VS-readonly<% } %>">
            <div class="VS-search-box-wrapper VS-search-box">
              <div class="VS-icon VS-icon-search"></div>
              <div class="VS-placeholder"></div>
              <div class="VS-search-inner"></div>
              <div class="VS-icon VS-icon-cancel VS-cancel-search-box" title="clear search"></div>
            </div>
          </div>
          """
        )

      searchFacetTemplate: ->
        _.template(
          """
          <% if (model.has(\'category\')) { %>
            <div class="category"><%= model.get(\'category\') %>:</div>
          <% } %>

          <div class="search_facet_input_container">
            <input type="text" class="search_facet_input ui-menu VS-interface" value="" <% if (readOnly) { %>disabled="disabled"<% } %> />
          </div>

          <div class="search_facet_remove VS-icon VS-icon-cancel"></div>
          """
        )

      searchInputTemplate: ->
        _.template(
          """
          <input type="text" class="ui-menu" <% if (readOnly) { %>disabled="disabled"<% } %> />
          """
        )

