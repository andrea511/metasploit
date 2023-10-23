define [
  'base_controller'
  'lib/shared/nexpose_push/nexpose_push_started_view'
], ->
  @Pro.module "Shared.NexposePush", (NexposePush, App, Backbone, Marionette, $, _) ->
    class NexposePush.StartedController extends App.Controllers.Application
      #
      # @param [Object] opts the options hash
      # @option opts :title [String]
      #   title to show in the modal
      # @option opts :buttons [Array<Object>]
      #   the array of button config for modal
      # @option opts :redirectUrl [String]
      #   the url link to the newly created task log kicked of by export run
      #
      initialize: (opts) ->
        _.defaults opts,
          title:   'Push To Nexpose'
          buttons: [ { name: 'OK', class: 'btn primary close' } ]
        {
        @buttons
        @title
        @redirectUrl
        } = opts

        @model = new Backbone.Model(redirectUrl: @redirectUrl)
        @setMainView(@_getModalView())

      _getModalView: ->
        @modalView = @modalView || new NexposePush.StartedView(model: @model)

      showModal: ->
        modalOptions =
          modal:
            title: @title
            hideBorder:true
            width:  400
          buttons: @buttons
        errorCallback = (data)->
          throw "Error with vulns:push:started"
        jQuery("a.nexpose").removeClass('submitting')
        App.execute "showModal", @, modalOptions, errorCallback

