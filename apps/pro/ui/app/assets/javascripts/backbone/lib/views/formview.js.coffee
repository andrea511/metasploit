define [
  'base_itemview'
  'lib/concerns/views/spinner'
], ->

  @Pro.module "Views", (Views, App, Backbone, Marionette, $, _) ->
      #
      # A view that incorporates a form for editing model data.
      #
      class Views.FormView extends Views.ItemView
        @include "Spinner"

        events:
          'change form' : 'updateModel'
          'input form'  : 'updateModel'

        modelEvents:
          'change:errors' : 'updateErrors'
          'request'       : 'disableForm'
          'sync'          : 'enableForm'

        ui:
          'form':           'form'
          'inputs':         'input, textarea'

        #
        # Render the model's content into the form
        onShow: () ->
          Backbone.Syphon.deserialize(@,@model.toJSON())
          @updateErrors(null,@model.get('errors'))

        onDestroy:()->
          @updateModel()

        #
        # Update the form's model with the data from the form.
        #
        # @return [void]
        updateModel: () ->
          data = Backbone.Syphon.serialize(@)
          @model.set(data)

        #
        # Update the errors on the model. If `@nestedAttributeName` is defined on
        # the view, it will automatically filter out the correct errors to be rendered.
        #
        # @param model [Entities.Model] the view's model
        # @param errors [Object] the errors preventing the object from saving
        #
        # @example Override this method to provide custom filtering logic for errors.
        #
        #   updateErrors: (cred, errors) ->
        #     errors = _.filter errors, (error) ->
        #       error['public']?
        #     @_renderErrors(errors)
        #
        # @return [void]
        updateErrors: (model, errors) ->
          @enableForm()

          if @nestedAttributeName?
            errors = _.filter errors, (error) =>
              error[@nestedAttributeName]?
            errors = errors[0][@nestedAttributeName] if !_.isEmpty(errors) and errors[0][@nestedAttributeName]?

          @_renderErrors(errors)

        #
        # Disable the form and its inputs.
        #
        # @return [void]
        disableForm: ->
          @ui.form.css 'opacity', '0.5'
          @ui.inputs.disable() if @ui.inputs.size > 0
          @showSpinner()

        # Enable the form and its inputs.
        enableForm: ->
          @ui.form.css 'opacity', '1'
          @ui.inputs.enable() if @ui.inputs.size > 0
          @hideSpinner()

        #
        # Helper methods
        #

        #
        # Render error messages under their respective form inputs. If `@nestedAttributeName`
        # is defined on the view, it will render errors for associated error keys under
        # inputs with the name `nestedAttributeName[inputName]`.
        #
        # @param errors [Object] the errors to be rendered
        #
        # @return [void]
        _renderErrors: (errors) =>
          # Remove existing errors from the view.
          $('.error', @el).remove()

          _.each errors, (v, k) =>
            for error in v
              name = if @nestedAttributeName? then "#{@nestedAttributeName}[#{k}]" else k

              $msg = $('<div />', class: 'error').text(error)
              $("[name='#{name}']", @el).addClass('invalid').after($msg)