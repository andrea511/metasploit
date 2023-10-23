define [
  'base_controller'
  'lib/components/file_input/file_input_views'
], ->
  @Pro.module "Components.FileInput", (FileInput, App, Backbone, Marionette, $, _) ->
    class FileInput.Controller extends App.Controllers.Application

      defaults: ->
        name: "file_input[data]"

      # Create new instance of the Cred Form
      #
      initialize: (options) ->
        #Set default key/values if key not defined in options hash
        config = _.defaults options, @_getDefaults()

        @layout = new FileInput.Input(model: new Backbone.Model(config))
        @setMainView(@layout)

      #
      # When we restore a file input in task chain we want to rebind the correct dom element
      rebindFileInput: () ->
        @_mainView.bindUIElements()
        @_mainView.undelegateEvents()
        @_mainView.delegateEvents()

      resetLabel: () ->
        @_mainView.resetLabel()

      clear: () ->
        @_mainView.clearInput()

      isFileSet: () ->
        @_mainView.isFileSet()


    # Register an Application-wide handler for a cred controller
    App.reqres.setHandler 'file_input:component', (options={})->
      new FileInput.Controller options