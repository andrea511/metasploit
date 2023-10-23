define [
  'base_layout'
  'base_formview'
  'apps/creds/clone/templates/clone_layout'
  'apps/creds/clone/templates/public'
  'apps/creds/clone/templates/private'
  'apps/creds/new/templates/realm'
  'apps/creds/clone/templates/type'
  'lib/components/flash/flash_controller'
  'lib/concerns/views/spinner'
], () ->
  @Pro.module 'CredsApp.Clone', (Clone, App, Backbone, Marionette, $, _) ->
    class Clone.Layout extends App.Views.Layout
      @include "Spinner"

      template: @::templatePath 'creds/clone/clone_layout'

      modelEvents:
        'change:errors' : 'renderErrors'

      regions:
        publicRegion:  'td.public'
        privateRegion: 'td.private'
        realmRegion:   'td.realm'
        typeRegion:    'td.type'

      events:
        'click a.save':   'onFormSubmit'
        'submit form':    'onFormSubmit'
        'click a.cancel': 'destroy'

      initialize: (options) ->
        { @credsCollection } = options
        super(options)

      #
      # Replace the contents of the tr with the empty div created by Backbone,
      # and set this item's element to its containing tr.
      #
      # @return [void]
      dropContainingEl: ->
        @setElement(@$el.parent())
        @$el.html(@$el.find('div').first().html())

      onFormSubmit: (e) ->
        e.preventDefault()

        @model.unset('errors')

        @showSpinner()

        # Since we're cloning, the type of cred will always be 'manual'.
        @model.save _.extend(@model.attributes, cred_type: 'manual'),
          success: =>
            App.vent.trigger 'cred:added', @credsCollection
            @destroy()
          error: (cred, response) =>
            @hideSpinner()
            errors = $.parseJSON(response.responseText).error
            @model.set 'errors', errors

      renderErrors: (cred, errors) ->
        errors = errors[0]?.core?.base

        if errors != undefined && errors.length > 0
          _.each errors, (error) ->
            App.execute 'flash:display',
              title: 'Credential not saved'
              style: 'error'
              message: "The credential #{error}"
              duration: 5000

    class Clone.Public extends App.Views.FormView
      template: @::templatePath 'creds/clone/public'

      nestedAttributeName: 'public'

      #
      # When the form is displayed, focus the username input and highlight its
      # contents.
      #
      # @return [void]
      onShow: ->
        super()
        @$(":text:visible:enabled:first").select()

    class Clone.Private extends App.Views.FormView
      template: @::templatePath 'creds/clone/private'

      nestedAttributeName: 'private'

      #
      # Update the form's model with the data from the form. Overridden
      # to ensure that both `private.data` and `private.type` are set
      # correctly, since `set` will override them (it does not deep merge attrs).
      #
      # @return [void]
      updateModel: () ->
        data = Backbone.Syphon.serialize(@)
        data.private.type = @model.attributes.private?.type

        @model.set(data)

    class Clone.Realm extends App.Views.FormView
      template: @::templatePath 'creds/new/realm'

      initialize: (opts) ->
        _.extend @ui,
          realmKeySelect: '#realm'

      nestedAttributeName: 'realm'

      # Ensure "None" is selected if the existing cred has no realm.
      onShow: ->
        unless @model.attributes.realm?.key
          @ui.realmKeySelect.val 'None'
          @model.get('realm').key = 'None'

        super()

    class Clone.Type extends App.Views.FormView
      template: @::templatePath 'creds/clone/type'

      nestedAttributeName: 'private'

      #
      # Update the form's model with the data from the form. Overridden
      # to ensure that both `private.data` and `private.type` are set
      # correctly, since `set` will override them (it does not deep merge attrs).
      #
      # @return [void]
      updateModel: () ->
        data = Backbone.Syphon.serialize(@)
        data.private.data = @model.attributes.private?.data

        @model.set(data)
