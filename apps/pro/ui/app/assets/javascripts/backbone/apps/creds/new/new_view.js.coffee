define [
  'base_view'
  'base_itemview'
  'base_layout'
  'apps/creds/new/templates/new_layout'
  'apps/creds/new/templates/realm'
  'apps/creds/new/templates/public'
  'apps/creds/new/templates/private'
  'apps/creds/new/templates/import'
], () ->
  @Pro.module 'CredsApp.New', (New, App, Backbone, Marionette, $, _) ->
    class New.Layout extends App.Views.Layout
      template: @::templatePath 'creds/new/new_layout'

      ui:
        cred_type: '.cred-type'
        tag_container: '.tag-container'
        errors: '.core-errors'

      triggers:
        'change [name="cred_type"]' : 'type:selected'
        'submit form': 'preventFormSubmit'

      modelEvents:
        'change:errors' : 'updateErrors'

      regions:
        tags: '.tags'
        formContainer: '.form-container.cred'
        loginFormContainer: '.login-form-container'

      hideCredTypes: () ->
        @ui.cred_type.css('visibility','hidden')


      # Update Form Errors
      updateErrors: (core, errors) ->
        errors = _.filter errors, (error) ->
          error['core']?
        @_renderErrors(errors)

      preventFormSubmit: (e) ->
        e.preventDefault()

      #
      # Helper methods
      #

      # Render the errors that effect the entire credential core
      #
      # @param [Object] errors hash of errors
      #
      # @return [void]
      _renderErrors: (errors) =>
        $('.error',@el).remove()
        if !_.isEmpty(errors) and errors[0]['core']?
          _.each errors[0]['core'], (v, k) =>
            for error in v
              $msg = $('<div />', class: 'error').text('The credential ' + error)
              @ui.errors.append $msg

    class New.Realm extends App.Views.ItemView
      template: @::templatePath "creds/new/realm"

      ui:
        realmOptions: '#realm option'
        realm: "#realm"
        name: '#name'
        nameLabel: '[for="name"]'

      events:
        'change form' : 'updateModel'
        'input form' : 'updateModel'
        'change @ui.realm': 'typeChanged'

      modelEvents:
        'change:errors' : 'updateErrors'

      # Setup Form
      onShow: () ->
        Backbone.Syphon.deserialize(@,@model.toJSON())
        @initUi()

      onDestroy:()->
        @updateModel()


      # Update the Model with serialized form data
      updateModel: () ->
        data = Backbone.Syphon.serialize(@)
        @model.set(data)

      # Update Form Errors
      updateErrors: (cred, errors) ->
        errors = _.filter errors, (error) ->
          error['realm']?
        @_renderErrors(errors)

      #
      # Helper methods
      #

      # Render the private cred errors
      # @param [Object] errors hash of errors
      _renderErrors: (errors) =>
        $('.error',@el).remove()
        if !_.isEmpty(errors) and errors[0]['realm']?
          _.each errors[0]['realm'], (v, k) =>
            for error in v
              name = "realm[#{k}]"
              $msg = $('<div />', class: 'error').text(error)
              $("input[name='#{name}']", @el).addClass('invalid').after($msg)

      # Set initial public type, set up form for selected type
      initUi: ()->
        unless @model.get('realm')?.key?
          @ui.realmOptions.first().attr('selected','selected')
          @ui.name.addClass('invisible')
        else
          e = {}
          e.target = $(':selected',@ui.realm)
          @typeChanged(e)
          Backbone.Syphon.deserialize(@,@model.toJSON())

        @updateErrors(null,@model.get('errors'))

      typeChanged: (e) ->
        selected = $(e.target).val()

        if selected == "None"
          @ui.name.addClass('invisible')
          @ui.nameLabel.addClass('invisible')
        else
          @ui.name.removeClass('invisible')
          @ui.nameLabel.removeClass('invisible')

    class New.Import extends App.Views.Layout
      template: @::templatePath "creds/new/import"

      ui:
        passwordType: '.password-type'
        importType: '.import-type'
        importTypeValue:   '[name="import[type]"]'
        fileInputRegion: '.file-input-region'
        importSelect: '[name="import[password_type]"]'
        nonReplayableValue: '[value="non-replayable"]'
        sshValue: '[value="ssh"]'

      events:
        'change form'  : 'updateModel'
        'change input' : 'updateModel'
        'change [name="import[type]"]' : 'updatePrivateType'

      modelEvents:
        'change:errors' : 'updateErrors'

      regions:
        fileInput: '.file-input-region'
        userFileInput: '.user-file-input-region'
        passFileInput: '.pass-file-input-region'

      onShow: () ->
        Backbone.Syphon.deserialize(@,@model.toJSON())
        window.Forms.renderHelpLinks(@el)

        if @model.get('import').type == 'pwdump' || @model.get('import').type == 'user_pass'
          @ui.importTypeValue.trigger('change')

      updateModel: () ->
        data = Backbone.Syphon.serialize(@)
        @model.set(data)

      updatePrivateType: (e) ->
        type = $(e.target).val()
        if type == "user_pass"
          $(@ui.importSelect).find(@ui.nonReplayableValue).prop('disabled', true)
          $(@ui.importSelect).find(@ui.sshValue).prop('disabled', true)
        else
          $(@ui.importSelect).find(@ui.nonReplayableValue).prop('disabled', false)
          $(@ui.importSelect).find(@ui.sshValue).prop('disabled', false)
        if type == "csv" || type == "user_pass"
          @ui.passwordType.css('visibility','visible')
        else
          @ui.passwordType.css('visibility','hidden')
        @updateFileInput(type)

      updateFileInput: (type) ->
        if type == "csv" || type == "pwdump"
          @ui.fileInputRegion.css('display', 'inline')
          $(".user-pass-file-input-region").css('display', 'none')
        else
          @ui.fileInputRegion.css('display', 'none')
          $(".user-pass-file-input-region").css('display', 'inline')

      updateErrors: (cred,errors) ->
        $('.error', @el).remove()
        if !_.isEmpty(errors) and errors['file_input']?
          if errors['file_input']['data']
            $msg = $('<div />', class: 'error').text(errors['file_input']['data'])
            $("input[name='file_input[data]']", @el).addClass('invalid').after($msg)
          if errors['file_input']['username']
            $msg = $('<div />', class: 'error').text(errors['file_input']['username'])
            $("input[name='file_input[username]']", @el).addClass('invalid').after($msg)
          if errors['file_input']['password']
            $msg = $('<div />', class: 'error').text(errors['file_input']['password'])
            $("input[name='file_input[password]']", @el).addClass('invalid').after($msg)



    class New.Public extends App.Views.ItemView
      template: @::templatePath "creds/new/public"

      events:
        'change form' : 'updateModel'
        'input form' : 'updateModel'

      modelEvents:
        'change:errors' : 'updateErrors'

      # Setup Form
      onShow: () ->
        Backbone.Syphon.deserialize(@,@model.toJSON())
        @updateErrors(null,@model.get('errors'))

      onDestroy:()->
        @updateModel()

      # Update the Model with serialized form data
      updateModel: () ->
        data = Backbone.Syphon.serialize(@)
        @model.set(data)

      # Update Form Errors
      updateErrors: (cred,errors) ->
        errors = _.filter errors, (error) ->
          error['public']?
        @_renderErrors(errors)

      #
      # Helper methods
      #

      # Render the public cred errors
      # @param [Object] errors hash of errors
      _renderErrors: (errors) =>
        $('.error', @el).remove()
        if !_.isEmpty(errors) and errors[0]['public']?
          _.each errors[0]['public'], (v, k) =>
            for error in v
              name = "public[#{k}]"
              $msg = $('<div />', class: 'error').text(error)
              $("input[name='#{name}']", @el).addClass('invalid').after($msg)

    class New.Private extends App.Views.ItemView
      template: @::templatePath "creds/new/private"

      ui:
        type: '#type'
        typeOptions: '#type option'
        options: '.option'
        data: '#data'

      events:
        'change @ui.type' : 'typeChanged'
        'change form' : 'updateModel'
        'input form' : 'updateModel'

      modelEvents:
        'change:errors': 'updateErrors'

      # Setup Form
      onShow: () ->
        Backbone.Syphon.deserialize(@,@model.toJSON())
        @initUi()
        @updateErrors(null,@model.get('errors'))

      onDestroy:()->
        @updateModel()

      # Update the Model with serialized form data
      updateModel: () ->
        data = Backbone.Syphon.serialize(@)
        @model.set(data)

      # Update Form Errors
      updateErrors: (cred,errors) ->
        errors = _.filter errors, (error) ->
          error['private']?
        @_renderErrors(errors)

      # Set initial private type, set up form for selected type
      initUi: ()->
        unless @model.get('private')?.type?
          @ui.typeOptions.first().attr('selected','selected')
          @ui.data.addClass('invisible')
        else
          $(':selected',@ui.type).change()
          Backbone.Syphon.deserialize(@,@model.toJSON())

      #
      # Helper methods
      #

      # Render the private cred errors
      # @param [Object] errors hash of errors
      _renderErrors: (errors) =>
        $('.error',@el).remove()
        if !_.isEmpty(errors) and errors[0]['private']?
          _.each errors[0]['private'], (v, k) =>
            for error in v
              name = "private[#{k}]"
              $msg = $('<div />', class: 'error').text(error)
              $("[name='#{name}']", @el).addClass('invalid').after($msg)

      # Update Form Options when selecting private cred type
      # @param e [Object] change event
      replaceWithInput:(el) ->
        newEl = jQuery("<input>")
        newEl.attr('type', 'text').attr('id','data').attr('name', "private[data]")
        $("#data").replaceWith(newEl)
      replaceWithTextArea: ->
        newEl = jQuery("<textarea>")
        newEl.attr('id','data').attr('name', "private[data]").attr('rows','4')
        $("#data").replaceWith(newEl)
      blankInput: ->
        jQuery("#data").addClass('invisible')
      typeChanged: (e) ->
        selected = $(e.target).val()
        @ui.options.addClass('invisible')
        $(".option.#{selected}", @el).removeClass('invisible')

        if selected=="none"
          @ui.data = @ui.data.addClass('invisible')
        else
          @ui.data = @ui.data.removeClass('invisible')

        if @ui.type.val() == 'plaintext'
          @replaceWithInput()
        else if @ui.type.val() != 'none'
          @replaceWithTextArea()
        else
          @blankInput()

