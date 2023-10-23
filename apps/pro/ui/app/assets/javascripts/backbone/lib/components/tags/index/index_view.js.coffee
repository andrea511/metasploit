define [
  'jquery',
  'lib/components/tags/index/templates/layout'
  'lib/components/tags/index/templates/tag_composite'
  'base_view'
  'base_itemview'
  'base_layout'
  'base_compositeview'
], ($, Template, TokenInput, ModalForm) ->
  @Pro.module 'Components.Tags.Index', (Index, App, Backbone, Marionette, $, _) ->

    NAME_SYMBOL = "$NAME"
    DELETE_CONFIRM_MESSAGE = "Are you sure you want to remove the tag \"#{NAME_SYMBOL}\?"

    #
    # Layout view containing Add Tags Button and the Composite View of Tags
    #
    class Index.Layout extends App.Views.Layout
      template: @::templatePath 'tags/index/layout'

      ui:
        tagCount: '.tag-count a'
        tags: '.tags>.row'

      regions:
        tagHover: '.tag-hover-region'

      events:
        'mouseenter @ui.tagCount': 'setHoverTimeout'
        'mouseleave @ui.tags': 'clearHoverTimeout'
        'mouseleave @ui.tagCount' :'clearHoverTimeout'
        'mouseleave @ui.tags' : 'setHideHoverTimeout'
        'mouseenter @ui.tags':  'clearHideHoverTimeout'
        'mouseleave' : 'setHideHoverTimeout'

      #
      # Show Tags on hover after time delay
      #
      setHoverTimeout: ->
        unless !(@model?.tagUrl?) and parseInt(@model?.get('tag_count')) == 0
          @hoverTimeout = setTimeout(@triggerHover, 100)

      #
      # Prevent hover from appearing
      #
      clearHoverTimeout: ->
        clearTimeout(@hoverTimeout)

      #
      # Hide hover after time delay
      #
      setHideHoverTimeout: ->
        @hideHoverTimeout = setTimeout(@triggerHideHover,200)

      #
      # Prevent hover from being hidden
      #
      clearHideHoverTimeout: ->
        clearTimeout(@hideHoverTimeout)

      #
      # Callback for hover
      #
      triggerHover: =>
        @trigger('show:tag:hover')

      #
      # Callback for hide hover
      #
      triggerHideHover: =>
        @trigger('hide:tag:hover')

      #
      # Increment Tag Count
      #
      increment: (increment=1) ->
        count = parseInt(@ui.tagCount.html())+increment
        @ui.tagCount.html(_.escape("#{count} tags"))

      #
      # Decrement Tag Counter
      #
      decrement: (decrement=1) ->
        count = parseInt(@ui.tagCount.html())-decrement
        @ui.tagCount.html(_.escape("#{count} tags"))


    #
    # View containing list of tags
    #
    class Index.TagCompositeView extends App.Views.CompositeView
      template: @::templatePath 'tags/index/tag_composite'

      className: 'tags'

      events:
        'click a.tag-close': 'deleteTagClicked'
        'click a.green-add': 'addTagClicked'

      modelEvents:
        'change': 'render'

      ui:
        tag: '.tag-count'

      initialize: (opts) ->
        @serverAPI = opts.serverAPI
        @model = opts.model

        super(opts)

      #
      # Serialize data to pass into template
      #
      serializeData: ->
        tags = @model.get('tags') || []
        {
          model: @model,
          lastTags: tags,
          tagCount: tags.length,
          workspace_id: @model.get('workspace_id')
        }


      #
      # Show Add Tag Modal when add tag button clicked
      #
      # @param e [event] the click event
      #
      addTagClicked: (e) ->
        e.preventDefault()
        id = @model.get('id')
        return if !id or id <1

        ids = [id]

        # Coerce IDs into a collection of models with only id attributes
        models = _.map(ids, (id)-> new Backbone.Model({id: id}))
        collection = new Backbone.Collection(models)

        # Stub out query string for filtered tags
        query = ""
        #If tagUrl defined in backbone model or on model as an attribute by rails presenter
        url =  if @model.tagUrl? then url= @model.tagUrl() else url= @model.get('tagUrl')

        # show tagging modal
        controller = App.request 'tags:new:component', collection,
          q: query
          url: url
          content: @model.get 'taggingModalHelpContent'
          serverAPI: @serverAPI
          tagSingle: true

        App.execute "showModal", controller,
          modal:
            title: 'Tags'
            description: ''
            height: 170
            width: 400
            hideBorder: true
          buttons: [
            {name: 'Cancel', class: 'close'}
            {name: 'OK', class: 'btn primary'}
          ]
          doneCallback: () =>
            @trigger("tag:increment", controller.tagCount)
            App.vent.trigger 'core:tag:added', @model.collection

      #
      # "X" clicked on a single tag
      #
      # @param e [Event] the click event
      #
      deleteTagClicked: (e) =>
        e.preventDefault()
        id = parseInt($(e.currentTarget).attr('data-id'))
        return if !id or id <1

        # show confirmation dialog
        tagName = _.string.trim($(e.currentTarget).prev('a.tag').text())
        confirmMsg = DELETE_CONFIRM_MESSAGE.replace(NAME_SYMBOL,tagName)
        return unless confirm(confirmMsg)

        # remove the tag from the UI
        $wrap = $(e.currentTarget).closest('div')
        $(e.currentTarget).prev('a.tag').first().remove()
        $(e.currentTarget).remove()
        $wrap.remove()

        #Decrement tag count in UI, update model on server, trigger growl notification
        @model.removeTag(tagId: id, success: =>
          @trigger("tag:decrement")
          @render()
          App.vent.trigger 'core:tag:removed', @model.collection
        )

      #
      # Get tags for entity and show view
      #
      showTags: ->
        @model.fetchTags((model) =>
          @$el.css('display', 'block')
        )

      #
      # Hide tags view
      #
      hideTags: ->
        @$el.css('display','none')

      #
      # Clear any other tag hovers that may be displayed
      #
      clearTagHovers: ->
        $('.tag-hover-region>.tags').css('display','none')
