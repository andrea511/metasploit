jQuery ($) ->
  cloneDialog = null
  window.renderCloneDialog = ->
    d = $('#cloneWebsite .config .clone-web-options', @el).clone()
    $('.check-with-text', d).on 'change', ->
      textbox = $($(this).data('enabled-text'), $(this).closest('.checkbox-and-text'))
      if $(this).is(':checked')
        textbox.prop('disabled', false)
        textbox.focus()
      else
        textbox.prop('disabled', true)

    d.show().dialog
      title: 'Clone Website'
      modal: true
      width: 320
      closeOnEscape: false
      autoResize: true
      close: -> $(this).dialog('destroy').remove()
      open: -> # get in thurr
        $('.ui-dialog-buttonpane', $(this).parent()).show()
        _.defer((=>
          $('input', this).first().blur().delay(1).focus()
        ))
      buttons:
        "Cancel": ->
          $(this).dialog("close")
        "Clone": ->
          $('.ui-dialog-buttonpane', $(this).parent()).hide()
          $('>.clone-content', this).hide()
          $('>.loading', this).show()
          dataHash = $('.clone-content input', this).serializeArray()
          $form = $('.ui-tabs-wrap:visible form').first()
          $form = $('form').last() unless $form.size()
          action = $form.attr('action').replace(/\?.*$/, '').replace(/\/\d+$/, '')
          origin = "#{action}/clone_proxy.json"
          cloner = new HTMLCloner
            origin: origin
            success: (data, status) =>
              $('.ui-dialog-buttonpane', $(this).parent()).show()
              $('>.clone-content', this).show()
              $('>.loading', this).hide()
              if data['error']
                err = data['error']
                $('.clone-content .error', this).show().text(err)
              else
                $('.clone-content .error', this).hide()
                $form.trigger 'updateMirror', data.body
                $(this).dialog('close')
              
          cloner.cloneURL dataHash
