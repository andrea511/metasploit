define [
  'base_controller',
  'apps/imports/file/file_views'
  'lib/components/file_input/file_input_controller'
], ->
  @Pro.module "ImportsApp.File", (File, App) ->
    class File.Controller extends App.Controllers.Application

      initialize: (options)->
        @layout = new File.Layout()
        @setMainView(@layout)

        @listenTo @_mainView, 'show', =>
          @fileInput = App.request 'file_input:component', {name: 'file'}

          @show @fileInput, region: @_mainView.fileInputRegion

      useLastUploaded: (fileName) ->
        @_mainView.useLastUploaded(fileName)

      clearLastUploaded: ->
        @_mainView.clearLastUploaded()

    # Register an Application-wide handler for rendering a nexpose file import controller
    App.reqres.setHandler 'file:imports', (options={}) ->
      new File.Controller(options)
