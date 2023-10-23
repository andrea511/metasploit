$ = jQuery

$(document).ready ->
  $table      = $('table#backup-list')
  $checkboxes = $table.find('[type=checkbox]')
  $checkboxes.change ->
    any = $checkboxes.filter(':checked').length > 0
    any = false if $('#backup-list tbody tr').length is 0
    $('#backup-delete-submit').parent().toggleClass('disabled', !any)
    true

  $checkboxes.change()

  $table.find('td.toggle').click (e) ->
    e.preventDefault()
    e.stopImmediatePropagation()
    return if $(e.target).hasClass('disabled')
    return unless confirm($(e.target).attr('data-confirm'))
    $(e.target).addClass('disabled')
    $.ajax
      url: $(e.target).attr('href')
      type: 'POST'
      success: -> location.reload(true)

  $backup_restore_dialog = $('div#restore-backup-confirmation')
  $('input.restore').click (e) ->
    e.preventDefault()

    backup_name = $(this).attr('data-backup-name')
    $('span#backup-name').text(backup_name)

    $form = $('form#restore')
    $('<input>', {name: 'backup_name', value: backup_name, type: 'hidden'}).appendTo($form)

    $backup_restore_dialog.dialog
      modal: true
      draggable: false
      resizeable: false
      title: 'Are you sure?'
      width: 600
      buttons:
        'Cancel': ->
          $("button[title='close']").click();
        'Restore': ->
          $form.submit()

  $backup_delete_dialog = $('div#delete-backup-confirmation')
  $('#backup-delete-submit').click (e) ->
    $('#delete-backup-confirmation-list').html('')
    e.preventDefault()

    $('#backup-list td :checked').each ->
      $('#delete-backup-confirmation-list').append(
        $('<tr></tr>').html($(this).parent().siblings(".backup-data").clone()))

    $form = $(this).closest('form')
    $backup_delete_dialog.dialog
      modal: true
      draggable: false
      resizeable: false
      title: 'Are you sure?'
      width: 600
      buttons:
        'Cancel': ->
          $("button[title='close']").click();
        'Delete': ->
          $form.submit()
