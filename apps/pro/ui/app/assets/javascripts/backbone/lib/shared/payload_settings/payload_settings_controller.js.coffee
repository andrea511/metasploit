define [
  'base_controller'
  'lib/shared/payload_settings/payload_settings_views'
  'entities/shared/payload_settings'
], () ->
  @Pro.module "Shared.PayloadSettings" , (PayloadSettings, App, Backbone, Marionette, $, _) ->

    #
    # Contains the PayloadSettings
    #
    class PayloadSettings.Controller extends App.Controllers.Application

      # Hash of default options for controller
      #
      defaults: ->

      # Create a new instance of the Payload Controller and adds it to the
      # region passed in through the options hash
      #
      # @param [Object] options the option hash
      # @options opts :model contains the state for the payload settings
      initialize: (options = {}) ->
        {@model} = options

        @model = @model || App.request 'shared:payloadSettings:entities'

        layout = new PayloadSettings.View(model: @model)
        @setMainView(layout)

        @model.fetch()

        @listenTo @_mainView, 'show', ->
          Backbone.Syphon.deserialize(@_mainView, @model.toJSON())

      # Interface method required by {Components.Modal}
      #
      # @return [Promise] jQuery promise
      onFormSubmit: () ->
        # jQuery Deferred Object that closes modal when resolved.
        defer = $.Deferred()
        defer.promise()
        @_serializeForm()

        @model.save {},
          success: =>
            @model.set(validated:true)
            defer.resolve()
          error: (payloadSettings,response) =>
            @_mainView.updateErrors(response.responseJSON)
            @model.unset('validated')
        defer

      #
      # Serialize the form data into the backbone model
      #
      _serializeForm: () ->
        @model.set(Backbone.Syphon.serialize(@_mainView))