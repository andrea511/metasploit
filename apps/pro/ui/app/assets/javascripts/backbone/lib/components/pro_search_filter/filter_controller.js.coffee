define [
  'base_controller'
  'lib/components/pro_search_filter/filter_view'
#  'css!css/components/filter'
], ->
  @Pro.module "Components.ProSearchFilter" , (ProSearchFilter, App) ->

    #
    # Legacy search filter for tables, componentized to work with Carpenter tables
    # Swappable for Components.Filter (aka VisualSearch)
    # Note that server endpoint will be slightly different than for Components.Filter
    #
    # @opts filterOpts[:searchType] [String, required] must be 'pro' otherwise defaults
    #                                        to VisualSearch filter component
    # @opts filterOpts[:placeHolderText] [String, optional], the input placeholder text
    #
    # @example
    #   tableController = App.request "table:component"
    #     region: ...
    #     buttonsRegion: ...
    #     columns: ...
    #     collection: ...
    #     filterOpts:
    #       searchType: 'pro'
    #       placeHolderText: 'Search Vulns'
    #
    class ProSearchFilter.Controller extends App.Controllers.Application
      # Hash of default options for controller
      defaults: ->
        placeHolderText: 'Search...'

      # Creates a new instance of the FilterController and adds it to the
      # region passed in through the options hash
      #
      # @param [Object] options the option hash
      # @option opts region [Marionette.Region] the region into which we should render
      #   the filter
      initialize: (options = {}) ->
        # Set default key/values if key not defined in options hash
        # @config = _.defaults options, @_getDefaults()

        @filterView = @getFilterView(options)
        @setMainView(@filterView)

        # Setup listener for query search
        @listenTo @filterView, 'pro:search:filter:query:new', (query) ->
          @trigger 'pro:search:filter:query:new', query

      # Create view for this filter
      #
      # @param [Object] options the option hash
      # @return [Filter.FilterView] a view for the filter
      getFilterView: (options) ->
        new ProSearchFilter.FilterView options

    # Create a filter component Controller
    App.reqres.setHandler "pro:search:filter:component", (options={})->
      new ProSearchFilter.Controller options