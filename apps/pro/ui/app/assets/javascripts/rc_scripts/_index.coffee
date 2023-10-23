$ = jQuery

$(document).ready ->
  $table = $('table#rc-script-list')
  $master_checkbox = $table.find('[type=checkbox][name="all-rc-scripts"]')
  $slave_checkboxes = $table.find('[type=checkbox][name="rc-script-delete"]')
  $delete_button = $(".rc-scripts").find("input.delete")
  $upload_button = $(".rc-scripts").find("a.import")

  $master_checkbox.change ->
    master_state = $master_checkbox.prop('checked')
    $slave_checkboxes.prop('checked', master_state)

  $upload_button.click (e) ->
    $("#upload").click()

  $('#upload').change ->
    $('[value="Upload"]').click()

  $rc_script_delete_dialog = $('div#delete-rc-script-confirmation')
  $delete_button.click (e) ->
    $('#delete-backup-confirmation-list').html('')
    e.preventDefault()

    $slave_checkboxes.filter(':checked').each ->
      $(this.parentElement).find('[value="Delete"]').click()
      #$('#delete-backup-confirmation-list').append($('<tr></tr>').html($(this).parent().siblings(".rc-script-link").clone()))

#    $form = $(this).closest('form')
#    $rc_script_delete_dialog.dialog
#      modal: true
#      draggable: false
#      resizeable: false
#      title: 'Are you sure?'
#      width: 600
#      buttons:
#        'Cancel': ->
#          $("button[title='close']").click();
#        'Delete': ->
#          $form.submit()