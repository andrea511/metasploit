define [
  'jquery'
  'base_itemview'
  'lib/components/pro_search_filter/templates/filter'
  'css!css/components/pro_search_filter'
], ($) ->
  @Pro.module "Components.ProSearchFilter", (ProSearchFilter, App) ->

    #
    # View for the legacy pro_search filter component
    #
    class ProSearchFilter.FilterView extends App.Views.ItemView

      template: @::templatePath "pro_search_filter/filter"

      ui:
        container: '.filter-component'
        input:     'input'
        cancelButton: '.cancel-search'

      events:
        'keyup @ui.input': 'inputChanged'
        'click @ui.cancelButton': 'cancelClicked'

      SORT_BY:
        asc: 'asc'
        desc: 'desc'

      defaults: ->
        container: @ui.container
        query: ''
        sortBy: @SORT_BY.asc

      initialize: (options) ->
        @debouncedTriggerQuery = _.debounce(@_triggerQuery, 300)
        @model = new Backbone.Model
          placeHolderText: @options.filterOpts.placeHolderText

        @collection = @options.collection

      #
      # Set @options to options.filterOpts, if passed, or just to the options object
      setOptions: (options) ->
        # TODO: test this behavior
        opts = @options.filterOpts || @options
        _.defaults(opts, @defaults())
        @options = opts

      onRender: ->
        # Setting this here, rather than in initialize, since we need access to
        # @ui.container in defaults.
        @setOptions()

      inputChanged: ->
        @_toggleCancelButton()
        @triggerQuery(@_inputText())

      _inputText: -> @ui.input.val()

      _toggleCancelButton: ->
        if @_inputText() == ''
          @_hideCancelButton()
        else
          @_showCancelButton()

      _hideCancelButton: ->
        @ui.cancelButton.hide(200)

      _showCancelButton: ->
        @ui.cancelButton.show(200)

      cancelClicked: ->
        @_clearInputText()
        @inputChanged()

      _clearInputText: ->
        @ui.input.val('')

      #
      # Trigger a search query that ProCarpenter will pick up
      # query is a pure string with no fancy facet/key business
      # @example triggerQuery('doge')
      #
      # @return [void]
      #
      triggerQuery: (query) -> @debouncedTriggerQuery(query)
      _triggerQuery: (query)->
        @trigger 'pro:search:filter:query:new', query
