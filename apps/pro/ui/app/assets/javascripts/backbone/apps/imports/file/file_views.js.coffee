define [
  'base_layout'
  'base_view'
  'base_itemview'
  'apps/imports/file/templates/file_layout'
], () ->
  @Pro.module 'ImportsApp.File', (File, App, Backbone, Marionette, $, _) ->

    class File.Layout extends App.Views.Layout
      template: @::templatePath 'imports/file/file_layout'

      ui:
        blacklistHosts: '#nexpose_scan_task_blacklist_string'
        errors: '.error-container'
        useLastUploaded: '[name="use_last_uploaded"]'
        lastUploaded: '.last-uploaded'

      regions:
        fileInputRegion: '.file-input-region'

      showErrors: (errors) ->
        @ui.errors.css('display','block')
        @ui.errors.addClass('errors')
        @ui.errors.html(_.escape(errors))

      clearErrors: () ->
        @ui.errors.removeClass('errors')
        @ui.errors.html()

      clearLastUploaded: ->
        @lastUploaded = null
        @ui.lastUploaded.hide()
        @ui.useLastUploaded.val('')


      useLastUploaded: (fileName) ->
        @lastUploaded = fileName

        @ui.lastUploaded.show()
        @ui.lastUploaded.text("Last Uploaded: #{fileName}")
        @ui.useLastUploaded.val(fileName)