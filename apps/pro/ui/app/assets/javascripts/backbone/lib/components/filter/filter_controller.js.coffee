define [
  'base_controller'
  'lib/components/filter/filter_view'
  'css!css/components/filter'
  'lib/components/flash/flash_controller'
], ->
  @Pro.module "Components.Filter" , (Filter, App) ->

    #
    # Newer style search filter for carpenter tables
    # Features tokenized search inputs and autocomplete values for key and values.
    #
    # Note: This component is not typically instantiated on it's own, but is part of the
    # {Components.Table} and {Concerns.ProCarpenter}, and simply passed via filterOpts.
    #
    # This uses the DocumentCloud open-source library Visual Search (https://documentcloud.github.io/visualsearch/)
    # behind the scenes which we have also forked to our own repo (for feature enhancements as original project
    # is not maintained much) https://github.com/ccatalan-r7/visualsearch/tree/pro-proper
    #
    # The Autocomplete functionality requires a server endpiont, typically called filter_values, within the controller.
    # The final search query endpoint uses {Metasploit::Model::Search} behind the scenes
    # (which also follows a 'key:value' convention). See {DataResponder#apply_search_scopes}
    #
    class Filter.Controller extends App.Controllers.Application
      # Hash of default options for controller
      defaults: ->
        {}

      # Creates a new instance of the FilterController and adds it to the
      # region passed in through the options hash
      #
      # @param [Object] options the option hash
      # @option options region [Marionette.Region] the region into which we should render the filter
      # @option options filterValuesEndpoint [String] route path to the autocomplete drop-down values endpoint
      # @option options helpEndpoint [String] route path to the help endpoint. See Components.Filter#displayHelpModal
      # @option options keys [Array<String or Object>] collection of keys available to the search filter
      # @option options staticFacets [Object] [optional] collection of constant value/facets for a given key
      #
      # @example
      #   opts =
      #     region:               new Backbone.Marionette.Region({el: "#filter-region"})
      #     filterValuesEndpoint: Routes.related_hosts_filter_values_workspace_vuln_path WORKSPACE_ID, VULN_ID
      #     helpEndpoint:         Routes.search_operators_workspace_vuln_path WORKSPACE_ID, VULN_ID
      #     keys:                 [{label: 'host.address', value: 'address'}
      #                            {label: 'host.name',    value: 'name'}
      #                            {label: 'host.os_name', value: 'os_name'}]
      #     staticFacets:         'private.type': [{ value: 'SSH key', label: 'SSH Key' }
      #                                            { value: 'NTLM hash', label: 'NTLM Hash' }]
      #   filter = App.request 'filter:component', opts
      #
      initialize: (options = {}) ->
        # Set default key/values if key not defined in options hash
        # @config = _.defaults options, @_getDefaults()

        @filterView = @getFilterView(options)
        @setMainView(@filterView)

        # Setup listener for query search
        @listenTo @filterView, 'filter:query:new', (query) ->
          @trigger 'filter:query:new', query

      # Create view for this filter
      #
      # @param [Object] options the option hash
      # @return [Filter.FilterView] a view for the filter
      getFilterView: (options) ->
        new Filter.FilterView options

    # Create a filter component Controller
    App.reqres.setHandler "filter:component", (options={})->
      new Filter.Controller options