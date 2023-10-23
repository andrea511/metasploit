define [
  'base_view'
  'base_itemview'
  'base_layout'
  'apps/creds/new/templates/new_layout'
  'lib/components/file_input/templates/file_input'
], () ->
  @Pro.module 'Components.FileInput', (FileInput, App, Backbone, Marionette, $, _) ->
    class FileInput.Input extends App.Views.ItemView
      template: @::templatePath 'file_input/file_input'
      className: 'data file input'
      tagName: 'li'

      ui:
        file_input: '[type="file"]'
        file_label: 'label p'

      events:
        'change input:file' : 'changed'

      triggers:
        'change @ui.file_input': 'file:changed'

      resetLabel: () ->
        @bindUIElements()
        path = @ui.file_input.val()?.replace(/.*(\\|\/)/g, '')

        if path == ''
          path = "No file selected..."

        @fileSet = false
        @ui.file_label.text(path)

      clearInput: () ->
        @ui.file_input.wrap('<form>').parent('form').trigger('reset')
        @ui.file_input.unwrap()
        @resetLabel()

      changed:(e) ->
        $p = $('label p',@$el)
        path = $(e.target).val().replace(/.*(\\|\/)/g, '')

        if path && path.length > 0
          @fileSet = true
          $p.text(path)
        else
          @fileSet = false
          @ui.file_input.wrap('<form>').parent('form').trigger('reset')
          @ui.file_input.unwrap()
          $p.html(@setFileText($('input', @$el).attr('id')))

      onRender: =>
        that = this
        $('input:file', @el).each ->
          $label = $(@).prev()
          origText = $label.text() || 'file'
          $(@).attr('size', '50').css(overflow: 'hidden')
          $p = $('<p>').text(that.setFileText($(@).attr('id')))
          $span = $('<span>').text("Choose #{origText}...")
          $label.html('').append($p).append($span)
          $(@).change ->
            path = $(@).val().replace(/.*(\\|\/)/g, '')
            if path && path.length > 0
              $p.text(path)
            else
              $p.html('&nbsp;')

      isFileSet: ->
        @fileSet

      setFileText:(attr) ->
        idSpecificText = attr.split('_', 2)[0]
        if idSpecificText != "file" then idSpecificText = "#{idSpecificText} file"
        return "No #{idSpecificText} selected..."
