jQuery ($) ->
  $(document).ready ->
    $("#all_exceptions").checkAll $("#exception_list")

    $("#nexpose_exception_push_task_expiration_set").live 'change', ->
      $("#nexpose_exception_push_task_expiration_date_input").toggle $("#nexpose_exception_push_task_expiration_set").is(':checked')
    $("#nexpose_exception_push_task_expiration_set").change()

    tmrw = new Date
    tmrw.setDate(new Date().getDate() + 1)
    $("#nexpose_exception_push_task_expiration_date").datepicker(
      dateFormat: "yy-mm-dd",
      minDate: tmrw
    )

    resetFormValues = (reason, comment) ->
      $f = $('form#new_nexpose_exception_push_task')
      if reason && reason.length > 0
        $('select>option', $f).removeAttr('selected')
        $('select>option[value="'+reason+'"]').attr('selected', 'selected')
      $('textarea', $f).val(comment) if comment

    $("#exceptions .ctrls .btn a").click (e) ->
      $('#reset-form').dialog
        title: "Reset Form Values"
        width: 430
        height: 220
        autoOpen: true
        modal: true
        buttons:
          "Cancel": ->
            $(this).dialog("close")
          "Reset form values": ->
            comment = $('textarea[name=comment]', $(this)).val()
            reason = $('select[name=reason]>option:selected', $(this)).val()
            resetFormValues(reason, comment)
            $(this).dialog("close")
        open: ->
          $('textarea', $(this)).val('')
          $('select>option', $(this)).removeAttr('selected').eq(0).attr('selected', 'selected')
      e.preventDefault()