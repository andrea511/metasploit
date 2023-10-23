define [
  'base_itemview'
  'apps/imports/sonar/templates/domain_input_view'
], () ->
  @Pro.module 'ImportsApp.Sonar', (Sonar, App, Backbone, Marionette, $, _) ->

    #
    # View for Domain Input field / Query Button
    #
    class Sonar.DomainInputView extends App.Views.ItemView
      template: @::templatePath 'imports/sonar/domain_input_view'

      ui:
        inputText:   '#sonar-domain-input-textbox'
        queryButton: '#sonar-domain-query-button'
        errors:      '#sonar-domain-input-error-container'
        lastSeen: '#sonar-last-seen-input'

      events:
        'click @ui.queryButton': '_queryClicked'
        'keyup @ui.inputText': '_inputChanged'

      modelEvents:
        'change:domainUrl': '_domainChanged'

      onShow: ->
        @_initQueryTooltip()

      _initQueryTooltip: ->
        #Enable pointer events when disabled due to disabled class so we can see tooltip
        @ui.queryButton.css('pointer-events','all')
        @ui.queryButton.attr('title', "Must enter a domain")
        @ui.queryButton.tooltip()

      _domainChanged: (model,val) ->
        if val.length > 0
          @_enableQuery()
          @model.set('disableQuery',false)
        else
          @_disableQuery()
          @model.set('disableQuery',true)


      _queryClicked: ->
        console.log 'query clicked'
        domain = @ui.inputText.val()
        @_queryDomain(domain)

      # TODO: Add debounce
      _inputChanged: (e) ->
        text = e.target.value
        @model.set('domainUrl',text)
        @trigger 'input:changed', text

      _disableQuery: ->
        @_initQueryTooltip()
        @ui.queryButton.addClass('disabled')

      _enableQuery: ->
        @ui.queryButton.tooltip('disable')
        @ui.queryButton.removeClass('disabled')

      getInputText: ->
        @ui.inputText.val()

      getLastSeen: ->
        @ui.lastSeen.val()

      #
      # Hit's the Sonar endpoint for querying results on domain
      #
      # @param [String] domain - the domain to search
      #
      _queryDomain: (domain) ->
        return unless domain.trim().length > 0
        if @_validateDomain(domain)
          # TODO implement logic to query sonar endpoint
          console.log "Querying Sonar for domain <#{domain}>..."
          # TODO: change domain to domainUrl to be consistent everywhere
          @trigger 'query:submit', domain
        else
          @showErrors "#{domain} is not a valid domain"

      #
      # Validates domain string for Sonar
      #
      # @param [String] domain - the domain to search
      #
      _validateDomain: (domain) ->
        return true
        # TODO: Implement validations

      # TODO: Could this be a mixin?
      showErrors: (errors) ->
        @ui.errors.css('display','block')
        @ui.errors.addClass('errors')
        @ui.errors.html(_.escape(errors))

      clearErrors: () ->
        @ui.errors.removeClass('errors')
        @ui.errors.html()
