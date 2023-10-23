define [
  'jquery'
  'base_controller'
  'lib/components/tags/new/new_view'
], ($) ->
  @Pro.module "Components.Tags.New", (New, App, Backbone, Marionette, $, _) ->

    class New.Controller extends App.Controllers.Application
      #
      # Create a new instance of the NewController
      #
      # @option opts selectAllState     [Boolean] passed in by table component to indicate checkbox state
      # @option opts q                  [String] query string for jquery.tokenInput plugin
      # @option opts url                [String] url to fetch existing tags used by jquery.tokenInput
      # @option opts content            [String] text for the hover tooltip
      # @option opts entity             [Entity.Model] model to tag
      initialize: (options) ->
        _.defaults(options,
          selectAllState: false
          q: ''
          url: ''
          content: "Default Text"
        )

        {
        @q, @url, @entity, @selectAllState, @selectedIDs,
        @deselectedIDs, content, @serverAPI, @ids_only,
        @tagSingle
        } = options

        @tagForm = new New.TagForm(model: new Backbone.Model({content: content}))

        @listenTo @tagForm, 'token:changed', () =>
          @tagCount = @tagForm.tokenInput.tokenInput('get').length

        @setMainView(@tagForm)


      #
      # Get options to initialize tokenInput plugin
      #
      # @return [Hash]  Hash of config options for tokenInput plugin
      getDataOptions: () ->
        tokens = _.map(@getTokens(), (tok) -> tok.name)

        if @selectAllState?
          selectionOpts =
            select_all_state: ( @selectAllState )
            selected_ids:     @selectedIDs
            deselected_ids:   @deselectedIDs
        else
          selectionOpts =
           ignore_if_no_selections: true

        entity_ids: @entity.map((entity) -> entity.id)
        new_entity_tags: tokens.join(',')
        preserve_existing: true
        q: @q
        search: @serverAPI?.search
        ids_only: @ids_only
        tag_single: @tagSingle
        selections:
          selectionOpts

      #
      # Get tokens
      # @see http://loopj.com/jquery-tokeninput/ for API library
      #
      # @return [Hash] Hash of tokens
      getTokens: () ->
        @_mainView._nameField().data('tokenInputObject').getTokens()

      #
      # Clear tokens
      # @see http://loopj.com/jquery-tokeninput/ for API library
      #
      clearTokens: ->
        @_mainView._nameField().data('tokenInputObject').clear()

      #
      # Restore tokens
      # @see http://loopj.com/jquery-tokeninput/ for API library
      #
      # @param [Array<Token Object>] tokens collection of tag models to restore
      #
      restoreTokens: (tokens=[]) ->
        for token in tokens
          @tagForm.tokenInput.tokenInput('add',
            id: token.id
            name: token.name
          )

      #
      # Add tokens to tag form
      # @see http://loopj.com/jquery-tokeninput/ for API library
      #
      # @param [Array<String>] tokens collection of token names to add as tags
      #
      addTokens: (tokens=[]) ->
        for token in tokens
          @tagForm.tokenInput.tokenInput 'add', {name: token}

      #
      # Handler for when tag form submitted
      #
      onFormSubmit: () =>
        @_mainView._removeError()

        defer = $.Deferred()

        formSubmit = () =>
          $.ajax
            url: @url
            method: 'POST'
            data: @getDataOptions()
            success: (x) =>
              if x.error
                @_mainView._showError(x.error)
              else
                defer.resolve("success")
            error: (x) =>
              defer.reject("failure")
              json = $.parseJSON(x.responseText)
              @_mainView._showError(json.error)

        defer.promise(formSubmit)
        formSubmit

    # Reqres Handler to create the New Tagging Component
    App.reqres.setHandler 'tags:new:component', (entity ,options={})->
      options.entity = entity
      new New.Controller options
